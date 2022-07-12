class GamesController < ApplicationController
  def index
    @sentences = Sentence.all.map{|sentence| sentence }
    @sentences_content = Sentence.all.map(&:content)
  end
end
