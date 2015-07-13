class ChampionshipsController < ApplicationController
  respond_to :json, :html

  def index
    respond_with(current_referee.championships, location: "")
  end

  def create
    championship = current_referee.championships.create(params.require(:championship).permit(:title))
    respond_with(championship, location: "")
  end

  def show
    begin
      championship = current_referee.championships.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: {message: "Does not exist"}, status: :not_found
      return
    end 
    render json: championship.as_json(include: [:players, :games])
  end

  

end