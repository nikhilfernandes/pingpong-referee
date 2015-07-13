class HomeController < ApplicationController
  skip_before_filter :authenticate_referee!, :only => [:index]
  def index
    if current_referee.nil?
      redirect_to referee_login_path
      return
    end
  end

end