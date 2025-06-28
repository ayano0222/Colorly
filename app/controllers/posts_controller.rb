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
    # ベースは公開投稿
    @posts = Post.published

    # ------------ 1) フリーワード ------------
    if params[:search].present?
      @posts = @posts.where('location LIKE ?', "%#{params[:search]}%")
    end

    # ------------ 2) タグ絞り込み ------------
    if params[:tag_ids]
      tag_posts = []

      params[:tag_ids].each do |key, value|
        next unless value == "1"        # チェックされたタグだけ
        next unless (tag = Tag.find_by(name: key))

        tag_posts = tag_posts.empty? ? tag.posts.to_a : tag_posts & tag.posts.to_a
      end

      
      @posts =
        if tag_posts.empty?
          Post.none                         # 0 件の Relation
        else
          Kaminari.paginate_array(tag_posts).page(params[:page]).per(10)
        end
    else
      # タグ検索をしていないときは普通にページング
      @posts = @posts.page(params[:page]).per(10)
    end

    # ------------ 3) タグの新規登録（任意）------------
    Tag.create(name: params[:tag]) if params[:tag]
  end
 

  def show
    @post = Post.find(params[:id])
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