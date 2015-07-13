class PlayersController < ApplicationController
  respond_to :json
  skip_before_filter :authenticate_referee!, :only => [:create]

  def create 
    championship = Championship.find(params[:championship_id])   
    player = championship.players.create(params.require(:player).permit(:identity, :name, :defence_length, :host, :port, :path))    
    respond_with(player, location: "")
  end

end