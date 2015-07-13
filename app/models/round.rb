class Round < ActiveRecord::Base
  belongs_to :game

  before_save :validate_whos_chance

  def validate_whos_chance
    
  end
end