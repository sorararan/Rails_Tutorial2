class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      log_in user
      params[:session][:remember_me] == '1' ? remember(user) : forget(user)
      flash[:success] = "ログインしました"
      redirect_to user
    else
      flash.now[:error] = 'ログインに失敗しました'
      render sessions_new_path
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to static_pages_home_path
  end
end
