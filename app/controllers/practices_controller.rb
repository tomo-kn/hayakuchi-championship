class PracticesController < ApplicationController
  before_action :require_login, only: %i[result destroy]
  before_action :set_result, only: %i[result destroy]
  before_action :user_check, only: %i[result destroy]
  def index
    @sentences = Sentence.all
  end

  def show
    @sentence = Sentence.find(params[:id])
  end

  def new
    @practice = Practice.new
  end

  def create
    @practice = Practice.new(practice_params)
    @practice.user_id = current_user.id
    @practice.save
  end

  def result
    @sentence = Sentence.find(@result.sentence_id)
  end

  def destroy
    @result.destroy
    redirect_to user_path(current_user.id)
  end

  
  private

    def practice_params
      params.permit(:score, :time, :word, :user_id, :sentence_id, :voice)
    end

    def set_result
      @result = Practice.find(params[:id])
    end
    
    def user_check
      @user = @result.user
      redirect_to login_path, danger: "ログインしてください" if current_user != @user
    end

end
