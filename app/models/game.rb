class Game < ActiveRecord::Base
  belongs_to :championship
  has_many :rounds

  module STATUS
    STARTED = "started"
    COMPLETED = "completed"
  end


  def update

  end




end