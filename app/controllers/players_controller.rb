class PlayersController < ApplicationController
  respond_to :json

  def create    
    player = Championship.find(params[:championship_id]).players.create(params.require(:player).permit(:identity, :name, :defence_length))
    respond_with(player, location: "")
  end

end