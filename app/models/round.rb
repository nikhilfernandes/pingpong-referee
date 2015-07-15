class Round < ActiveRecord::Base
  belongs_to :game
  
  validate :game_player
  validate :whos_chance  
  before_save :check_for_winner
  

  def whos_chance        
    errors.add(:turn, "Its not your turn.") if !turn_was.nil? && self.turn != turn_was    
  end

  def game_player
    if self.turn != self.game.player1_identity && self.turn != self.game.player2_identity
      errors.add(:game, "You playing the wrong game.")
    end
  end

  def new_turn
    if !self.turn.nil? && self.turn == self.game.player1_identity
      self.game.player2_identity
    elsif !self.turn.nil? && self.turn == self.game.player2_identity
      self.game.player1_identity
    end    
  end

  def check_for_winner
    if !self.offensive_number.nil? && !self.defensive_array.nil?
      if self.defensive_array.include?(self.offensive_number)
          self.winner = turn
      else
        self.winner = new_turn
      end
      game.update_score(self.winner)
    end
  end
end