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
      render json: round, status: :ok
      return
    else
      render json: { :errors => round.errors.full_messages }, status: :unprocessable_entity      
      return
    end
  end

  def validate_player!    
    championship = Championship.find(params[:championship_id])   
    auth_token = request.headers["HTTP_X_AUTHENTICATION_TOKEN"]
    player = auth_token && championship.players.where(auth_token: auth_token).first 
    unless player
      render json: {errors: {message: "You are not authorized to perform this operation.", auth_token: auth_token }}, status: :unauthorized
      return
    end                        
  end
end