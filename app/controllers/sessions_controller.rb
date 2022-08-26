class SessionsController < ApplicationController
  before_action :require_login, only: %i[destroy]
  def new
    @user = User.new
  end

  def create
    @user = login(params[:email], params[:password], params[:remember])
    if @user
      redirect_to root_path, success: "ログインに成功しました"
    else
      flash[:danger] = "ログインに失敗しました"
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, success: "ログアウトしました"
  end

  def guest_sign_in
    @user = User.new(user_params)

    @user.name = "ゲスト:" + SecureRandom.alphanumeric(12) 
    @user.email = SecureRandom.alphanumeric(15) + "@example.com" 
    @user.password = SecureRandom.alphanumeric(18)
    @user.password_confirmation = @user.password
    @user.save
    
    log_in @user
    redirect_to root_path, success: "ゲストユーザーとしてログインしました"
  end

  private

    def user_params
      params.permit(:name, :email, :password, :password_confirmation)
    end
end
