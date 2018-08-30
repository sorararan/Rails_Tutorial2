class UsersController < ApplicationController
  before_action :enforce_log_in, only: [:index, :following, :followers]
  
  def index
    @users ||= User.all.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    @micropost = current_user.microposts.build
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
    @title = "Following"
    following_followers_variables
  end

  def followers
    @title = "Followers"
    following_followers_variables
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end

    def following_followers_variables
      @user  = User.find(params[:id])
      @users = @user.following.paginate(page: params[:page])
    end

end
