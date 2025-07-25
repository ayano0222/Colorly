class UsersController < ApplicationController
  def index
    @users = User.page(params[:page]).per(5).reverse_order
  end
  
  def show
    @user = User.find(params[:id])

    if @user == current_user
      # 自分のマイページ → 全投稿（下書き含む）
      @posts = @user.posts.page(params[:page]).per(8).reverse_order
    else
      # 他人のマイページ → 公開投稿だけ
      @posts = @user.posts.where(status: 'published').page(params[:page]).per(8).reverse_order
    end

    @following_users = @user.following_user
    @follower_users = @user.follower_user
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)

    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id
            @is_room = true
            @room_id = current.room_id
          end
        end
      end
      unless @is_room
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end
  
  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to user_path(@user.id)
  end

  def follows
    user = User.find(params[:id])
    @users = user.following_user.page(params[:page]).per(3).reverse_order
  end
  
  def followers
    user = User.find(params[:id])
    @users = user.follower_user.page(params[:page]).per(3).reverse_order
  end
  
  def bookmarks
    @user = User.find(params[:id])
    @posts = @user.bookmarked_posts
  end
  
  private
  def user_params
    params.require(:user).permit(:name, :email, :profile, :profile_image, :personal_color)
  end

end
