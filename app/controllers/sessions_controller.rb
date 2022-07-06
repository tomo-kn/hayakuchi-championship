class SessionsController < ApplicationController
  before_action :require_login, only: %i[destroy]
  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password])
    if @user
      redirect_back_or_to root_path, success: "ログインに成功しました"
    else
      flash[:danger] = "ログインに失敗しました"
      render :new
    end
  end

  def destroy
    logout
    redirect_back_or_to root_path, success: "ログアウトしました"
  end
end
