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
    @posts = Post.published

    # フリーワード検索
    if params[:search].present?
      @posts = @posts.where('location LIKE ?', "%#{params[:search]}%")
    end

    # タグによる絞り込み
    if params[:tag_ids]
      tag_posts = []
      params[:tag_ids].each do |key, value|
        if value == "1"
          found_tag = Tag.find_by(name: key)
          tag_posts = tag_posts.empty? ? found_tag&.posts : tag_posts & found_tag&.posts if found_tag
        end
      end
      @posts = tag_posts unless tag_posts.empty?
    end

    @posts = @posts.page(params[:page]).reverse_order

    # タグの新規登録（必要なら）
    if params[:tag]
      Tag.create(name: params[:tag])
    end
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
