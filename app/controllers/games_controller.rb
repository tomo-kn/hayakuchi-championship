class GamesController < ApplicationController
  before_action :require_login, only: %i[create destroy]
  before_action :set_result, only: %i[destroy]
  before_action :user_check, only: %i[destroy]
  
  def index
    @sentences = Sentence.all.map{|sentence| sentence }
    @sentences_content = Sentence.all.map(&:content)
    @sentences_contentFurigana = Sentence.all.map(&:contentFurigana)
    @sentences_contentMisconversion = Sentence.all.map(&:contentMisconversion)

    if logged_in?
      if Game.exists?(user_id: current_user.id)
        @games = Game.where(user_id: current_user.id)
        @bestscore = @games.order(score: "DESC", out: "ASC").limit(1)
        @recentscore = @games.order(id: "DESC").limit(5)
      end
    end
  end
  
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.user_id = current_user.id
    @game.save
  end
  
  def destroy
    @result.destroy
    redirect_to user_path(current_user.id), success: "削除しました"
  end

  private

    def game_params
      params.permit(:score, :out, :user_id)
    end

    def set_result
      @result = Game.find(params[:id])
    end
    
    def user_check
      @user = @result.user
      redirect_to login_path, danger: "ログインしてください" if current_user != @user
    end
end
