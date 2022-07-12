class GamesController < ApplicationController
  def index
    @sentences = Sentence.all.map{|sentence| sentence }
    @sentences_id = Sentence.all.map(&:id)
    @sentences_content = Sentence.all.map(&:content)
  end
end
