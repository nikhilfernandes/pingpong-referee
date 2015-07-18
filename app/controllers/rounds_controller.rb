class RoundsController < ApplicationController
  respond_to :json
  skip_before_filter :authenticate_referee!, :only => [:update]
  before_filter :validate_player!
  skip_before_filter :verify_authenticity_token

  def update
    championship = Championship.find(params[:championship_id])
    if championship.status == Championship::Status::CLOSED
      render json: {errors: "This championship is closed."}, status: :unprocessable_entity
      return
    end
    game = championship.games.find(params[:game_id])
    round = game.rounds.find(params[:id])    
    round.update_attributes(params.require(:round).permit(:last_played_by, :defensive_array, :offensive_number))
    respond_with(round, location: "")    
  end

end