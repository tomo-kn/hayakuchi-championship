class PagesController < ApplicationController
  def index
    if logged_in?
      @user = User.find(current_user.id)
    end
  end
end
