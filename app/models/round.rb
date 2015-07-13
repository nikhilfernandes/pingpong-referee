class Round < ActiveRecord::Base
  belongs_to :game
  
  before_save :validate_game_player
  before_save :validate_whos_chance
  

  def validate_whos_chance    
    errors.add(:turn, "Its not your turn.") if self.turn != turn_was    
  end

  def validate_game_player
    if self.turn != self.game.player1_identity && self.turn != self.game.player2_identity
      errors.add(:game, "You playing the wrong game.")
    end
  end
end