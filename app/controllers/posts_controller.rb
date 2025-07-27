class PostsController < ApplicationController
  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    if @post.save
      redirect_to post_path(@post.id)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def index
    @posts = Post.published.includes(:user)

    # フリーワード検索
    if params[:search].present?
      @posts = @posts.where('location LIKE ?', "%#{params[:search]}%")
    end

    # タグ絞り込み
    if params[:tag_ids]
      tag_posts = []

      params[:tag_ids].each do |key, value|
        next unless value == "1"
        next unless (tag = Tag.find_by(name: key))
        tag_posts = tag_posts.empty? ? tag.posts.published.to_a : tag_posts & tag.posts.published.to_a
      end

      # ★ここでは一旦配列にする（joinsは使えない）
      @posts = tag_posts
    end

    # パーソナルカラー絞り込み
    if params[:personal_color].present?
      # ★ActiveRecord::Relation なら joins できるが、配列なら select で代用
      if @posts.is_a?(ActiveRecord::Relation)
       @posts = @posts.joins(:user).where(users: { personal_color: params[:personal_color] })
      else
        @posts = @posts.select { |post| post.user.personal_color == params[:personal_color] }
      end
    end

    # ページネーション（配列なら paginate_array）
    if @posts.is_a?(Array)
      @posts = Kaminari.paginate_array(@posts).page(params[:page]).per(6)
    else
      @posts = @posts.page(params[:page]).per(6)
    end
  end
 

  def show
    @post = Post.find(params[:id])

    # 「下書き」かつ「投稿者が自分でない」場合はリダイレクト
    if @post.status == 'draft' && @post.user != current_user
      redirect_to posts_path, alert: "この投稿は表示できません。"
      return
    end

    @comment = Comment.new
    @comments = @post.comments.page(params[:page]).per(7).reverse_order
    unless ViewCount.find_by(user_id: current_user.id, post_id: @post.id)
      current_user.view_counts.create(post_id: @post.id)
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    if @post.update(post_params)
      redirect_to post_path(@post.id)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    redirect_to posts_path
  end

  def confirm
    @posts = current_user.posts.draft.page(params[:page]).reverse_order
  end

  def bookmarks
    @posts = current_user.bookmark_posts.includes(:user, image_attachment: :blob).page(params[:page]).reverse_order
    # ビューは bookmarks.html.erb が自動で使われます
  end

  private

  def post_params
    params.require(:post).permit(:user_id, :location, :text, :image, :status, tag_ids: [])
  end
end