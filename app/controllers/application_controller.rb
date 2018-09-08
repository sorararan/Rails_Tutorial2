class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper

  private
    # ログインしていないと入れないページに入れないようにする
    def enforce_log_in
      unless logged_in?
        store_location
        flash[:error] = "ログインしてください"
        redirect_to sessions_new_path
      end
    end
end
