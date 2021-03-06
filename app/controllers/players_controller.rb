class PlayersController < ApplicationController
  respond_to :json
  skip_before_filter :authenticate_referee!
  skip_before_filter :verify_authenticity_token

  def create 
    championship = Championship.find(params[:championship_id])   
    player = championship.players.create(params.require(:player).permit(:identity, :name, :defence_length, :host, :port, :path))        
    return render json: player.as_json(:include => {:championship => { :methods => :number_of_players_joined}}), status: :created if player.valid?
    return render json: { :errors => player.errors.full_messages }, status: :unprocessable_entity
  end

end