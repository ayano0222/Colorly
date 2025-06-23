class BookmarksController < ApplicationController
  before_action :authenticate_user!

  def create
    post = Post.find(params[:post_id])
    current_user.bookmarks.find_or_create_by(post: post)
    redirect_to post_path(post), notice: "ブックマークしました"
  end

  def destroy
    post = Post.find(params[:post_id])
    bookmark = current_user.bookmarks.find_by(post: post)
    bookmark&.destroy
    redirect_to post_path(post), notice: "ブックマークを外しました"
  end

  def index
    @posts = current_user.bookmark_posts
  end
end