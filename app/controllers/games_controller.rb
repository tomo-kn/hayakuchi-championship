class GamesController < ApplicationController
  def index
    @sentences = Sentence.all.map{|sentence| sentence }
    @sentences_content = Sentence.all.map(&:content)
    @sentences_contentFurigana = Sentence.all.map(&:contentFurigana)
    @sentences_contentMisconversion = Sentence.all.map(&:contentMisconversion)
  end
  
  def new
    @game = Game.new
  end

  def create
    @game = Game.new(game_params)
    @game.user_id = current_user.id
    @game.save
  end

  private

    def game_params
      params.permit(:score, :out, :user_id)
    end
end
