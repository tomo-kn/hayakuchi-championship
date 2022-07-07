class PracticesController < ApplicationController
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
  
  private

    def practice_params
      params.permit(:score, :time, :word, :user_id, :sentence_id)
    end

end
