class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_filter :authenticate_referee!

  def validate_player!    
    championship = Championship.find(params[:championship_id])   
    auth_token = request.headers["HTTP_X_AUTHENTICATION_TOKEN"]
    player = auth_token && championship.players.where(auth_token: auth_token).first     
    return render json: {errors: {message: "You are not authorized to perform this operation.", auth_token: auth_token }}, status: :unauthorized unless player
  end

end
