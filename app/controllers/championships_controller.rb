class ChampionshipsController < ApplicationController
  respond_to :json

  def create
    championship = current_referee.championships.create(params.require(:championship).permit(:title))
    respond_with(championship, location: "")
  end

end