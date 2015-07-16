class RoundsController < ApplicationController
  skip_before_filter :authenticate_referee!, :only => [:update]
  before_filter :validate_player!

  def update
    championship = Championship.find(params[:championship_id])
    game = championship.games.find(params[:game_id])
    round = game.rounds.find(params[:id])    
    round.update_attributes(params[:round])
    if round.valid?
      championship.round_completed
      return render json: round, status: :ok
      
    else
      return render json: { :errors => round.errors.full_messages }, status: :unprocessable_entity      
      
    end
  end

  def validate_player!    
    championship = Championship.find(params[:championship_id])   
    auth_token = request.headers["HTTP_X_AUTHENTICATION_TOKEN"]
    player = auth_token && championship.players.where(auth_token: auth_token).first     
    return render json: {errors: {message: "You are not authorized to perform this operation.", auth_token: auth_token }}, status: :unauthorized unless player
  end
end