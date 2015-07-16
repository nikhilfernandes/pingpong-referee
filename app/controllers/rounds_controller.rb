class RoundsController < ApplicationController
  skip_before_filter :authenticate_referee!, :only => [:update]
  before_filter :validate_player!

  def update
    championship = Championship.find(params[:championship_id])
    game = championship.games.find(params[:game_id])
    round = game.rounds.find(params[:id])    
    round.update_attributes(params[:round])
    respond_with(round, location: "")    
  end

end