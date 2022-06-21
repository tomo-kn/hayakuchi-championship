class PracticesController < ApplicationController
  def index
    @sentences = Sentence.all
  end

  def show
    @sentence = Sentence.find(params[:id])
  end

  def result
    @sentence = Sentence.find(params[:id])
  end
end
