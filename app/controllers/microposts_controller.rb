class MicropostsController < ApplicationController

  def create
    logged_in_user
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "投稿しました"
      redirect_to static_pages_home_path
    else
      flash.now[:error] = "投稿に失敗しました"
      # feed_itemsがnilになるのを防ぐ
      @feed_items = []
      redirect_to static_pages_home_path
    end
  end

  def destroy
    logged_in_user
    correct_user
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

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to static_pages_home_path if @micropost.nil?
    end
end
