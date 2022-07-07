class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper
  
  private

    def not_authenticated
      redirect_to login_path, danger: "ログインしてください"
    end

end
