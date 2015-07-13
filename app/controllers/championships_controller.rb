class ChampionshipsController < ApplicationController
  respond_to :json

  def index
    respond_with(current_referee.championships, location: "")
  end

  def create
    championship = current_referee.championships.create(params.require(:championship).permit(:title))
    respond_with(championship, location: "")
  end

  

end