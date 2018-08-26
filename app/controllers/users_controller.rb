class UsersController < ApplicationController
  
  def index
    logged_in_user
    @users ||= User.all.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = "ユーザの作成に成功しました"
      redirect_to @user
    else
      flash.now[:error] = "ユーザの作成に失敗しました"
      render new_user_path
    end
  end

  def following
    logged_in_user
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    logged_in_user
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def correct_user
      @user = User.find(params[:id])
      redirect_to(static_pages_home_path) unless current_user?(@user)
    end
end
