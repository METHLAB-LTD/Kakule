class AnswersController < ApplicationController
  def index
  end
  
  
  def show
    @answer = Answer.find(params[:id], :include => [:author, :itinerary_item])
  end
  
  # /questions/1/answers/new
  def new
    render :json => []
  end
  
end
