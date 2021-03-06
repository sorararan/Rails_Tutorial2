class MicropostsController < ApplicationController
  before_action :enforce_log_in, only: [:create, :destroy, :create_reply]

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "投稿しました"
      redirect_to static_pages_home_path
    else
      flash.now[:error] = "投稿に失敗しました"
      redirect_to static_pages_home_path
    end
  end

  def create_reply
    @micropost = current_user.microposts.build(reply_params)
    if @micropost.save
      flash[:success] = "返信しました"
      redirect_to static_pages_home_path
    else
      flash.now[:error] = "返信に失敗しました"
      redirect_to static_pages_home_path
    end
  end

  def destroy
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to static_pages_home_path unless @micropost.present?
    if @micropost.destroy
      flash[:success] = "削除に成功しました"
      redirect_to request.referrer || static_pages_home_path
    else
      flash.now[:error] = "削除に失敗しました"
      redirect_to request.referrer || static_pages_home_path
    end
  end

  private
    
    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end 

    def reply_params
      params.require(:micropost).permit(:content, :picture, :micropost_id)
    end

end
