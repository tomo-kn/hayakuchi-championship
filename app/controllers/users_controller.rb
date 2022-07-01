class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      flash[:notice] = 'ユーザーの作成に成功しました'
      render 'index'
    else
      render 'new'
      flash.now[:alert] = 'ユーザーの作成に失敗しました'
    end
  end

  private
    def user_params
      params.require(:user).permit(:name, :email, :password)
    end
end
