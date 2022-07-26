class UsersController < ApplicationController
  before_action :require_login, only: [:show, :edit, :update]
  before_action :set_user, only: [:show, :edit, :update]
  before_action :set_practice_result, only: %i[show edit update destroy]

  def new
    @user = User.new
  end

  def create
    @user = User.create(user_params)
    if @user.save
      log_in @user
      flash[:success] = 'ユーザーの作成に成功しました'
      redirect_to root_path
    else
      flash.now[:alert] = 'ユーザーの作成に失敗しました'
      render :new
    end
  end

  def show
    @practice_results = current_user.practices.order(created_at: "DESC")
    @game_results = current_user.games.order(created_at: "DESC")
    @sentences = Sentence.all
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user)
    else
      render :edit
    end
  end

  private

    def set_user
      @user = User.find(current_user.id)
    end

    def set_practice_result
      @practice_result = Practice.find(params[:id])
    end

    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
