class PracticesController < ApplicationController
  before_action :require_login, only: %i[create result destroy]
  before_action :set_result, only: %i[result destroy]
  before_action :user_check, only: %i[result destroy]
  def index
    @sentences = Sentence.all
    if logged_in?
      @practices = Practice.where(user_id: current_user.id)
      @counts = @practices.group(:sentence_id).count
      @scores = @practices.group(:sentence_id).sum(:score)
    end
  end

  def show
    @sentence = Sentence.find(params[:id])
    if logged_in?
      if Practice.exists?(user_id: current_user.id, sentence_id: @sentence.id)
        @practices = Practice.where(user_id: current_user.id, sentence_id: @sentence.id)
        @bestscore = @practices.order(score: "DESC", time: "ASC").limit(1)
        @besttime = @practices.order(time: "ASC", score: "DESC").limit(1)
        @recentscore = @practices.order(id: "DESC").limit(5)
      end
    end
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
    redirect_to user_path(current_user.id), success: "削除しました"
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
