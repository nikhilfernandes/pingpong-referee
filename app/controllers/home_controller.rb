class HomeController < ApplicationController
  skip_before_filter :authenticate_referee!, :only => [:index]
  def index    
    return redirect_to referee_login_path if current_referee.nil?
  end

end