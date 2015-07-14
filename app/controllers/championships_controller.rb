class ChampionshipsController < ApplicationController
  respond_to :json, :html
  skip_before_filter :authenticate_referee!, :only => [:index]

  def new

  end

  def dashboard
  end


  def index
    if current_referee.nil?
      respond_with(Championship.all, location: "")
      return
    else
      respond_with(current_referee.championships, location: "")
      return
    end
  end

  def create
    championship = current_referee.championships.create(params.require(:championship).permit(:title))
    respond_with(championship, location: "")
  end

  def show
    begin
      championship = current_referee.championships.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      render json: {message: "Does not exist"}, status: :not_found
      return
    end 
    render json: championship.as_json(include: [:players, :games])
  end

end