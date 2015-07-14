class PlayersController < ApplicationController
  respond_to :json
  skip_before_filter :authenticate_referee!, :only => [:create]
  skip_before_filter :verify_authenticity_token

  def create 
    championship = Championship.find(params[:championship_id])   
    player = championship.players.create(params.require(:player).permit(:identity, :name, :defence_length, :host, :port, :path))    
    if player.valid?
      render json: player.as_json(include: [:championship]), status: :created
      return
    else
      render json: { :errors => player.errors.full_messages }, status: :unprocessable_entity
    end
    
  end

end