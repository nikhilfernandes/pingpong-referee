class ChampionshipsController < ApplicationController
  respond_to :json, :html
  skip_before_filter :authenticate_referee!, :only => [:index]

  def new
  end

  def dashboard
  end

  def index    
    return respond_with(Championship.all, location: "") if current_referee.nil?
    return respond_with(current_referee.championships, location: "")
  end

  def create
    championship = current_referee.championships.create(params.require(:championship).permit(:title))
    respond_with(championship, location: "")
  end

  def show
    return respond_to { |format| format.html} if request.format == :html    
    begin
      championship = current_referee.championships.find(params[:id])
    rescue ActiveRecord::RecordNotFound => e
      return render json: {message: "Does not exist"}, status: :not_found      
    end 
    render json: championship.as_json(include: [:players, :games])
  end

end