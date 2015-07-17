class Round < ActiveRecord::Base
  belongs_to :game
  
  validate :game_player
  validate :whos_chance
  validates :offensive_number, :inclusion => { :in => 1..10, :message => "The offensive number should be between 1..10" }, :if => :offensive_number_present?
  validate :defensive_array_meets_condition
  after_save :handle_round_played
  after_create :notify_players_of_new_round

  module Outcome
    WON = "won"
    LOST = "lost"
  end

  def offensive_number_present?    
    !self.offensive_number.nil?
  end

  def defensive_array_meets_condition
    if !defensive_array.nil? 
      player = game.championship.players.find_by_identity(self.turn)
      if defensive_array.size != player.defence_length
        errors.add(:defensive_array, "The length of the defensive array is incorrect.")
      end
      if !defensive_array.detect{|num| !(1..10).to_a.include?(num) }.nil?
        errors.add(:defensive_array, "The numbers in defensive array are out of range..")
      end      
    end
  end
  

  def whos_chance        
    errors.add(:turn, "Its not your turn.") if  !self.last_played_by.nil? && self.last_played_by != self.turn    
  end

  def game_player
    if !self.last_played_by.nil? && self.last_played_by != self.game.player1_identity && self.last_played_by != self.game.player2_identity
      errors.add(:game, "You playing the wrong game.")
    end
  end

  def new_turn
    return self.game.player2_identity if !self.turn.nil? && self.turn == self.game.player1_identity      
    return self.game.player1_identity if !self.turn.nil? && self.turn == self.game.player2_identity
  end

  def round_over?
    !self.offensive_number.nil? && !self.defensive_array.nil?
  end

  def defensive_won?
    self.defensive_array.include?(self.offensive_number)
  end

  def offensive_won?
    !defensive_won?
  end

  def switch_turn
    self.update_column(:turn, new_turn)    
  end

  def winner_identity
    defensive_won? ? turn : new_turn
  end

  def loser_identity
    defensive_won? ? new_turn : turn
  end


  def handle_round_played
    if round_over?      
      self.update_column(:winner, winner_identity)      
      notify_player_of_outcome(winner_identity, Outcome::WON)
      notify_player_of_outcome(loser_identity, Outcome::LOST)         
      game.update_score(winner_identity)      
    else
      switch_turn unless turn_was.nil?
    end

    
  end

  def notify_player_of_outcome(player_identity, outcome)
    player = game.championship.players.find_by_identity(player_identity)
    player.notify_player_of_outcome_round(self.game.id, self.id, outcome)    
  end

  def notify_players_of_new_round
    player1 = Player.find_by_identity(game.player1_identity)
    player2 = Player.find_by_identity(game.player2_identity)
    if turn == player1.identity
      player1.notify_new_round(game.id, self.id, 1, Game::ROLE::OFFENSE)
      player2.notify_new_round(game.id, self.id, 2, Game::ROLE::DEFENSE)
    else
      player1.notify_new_round(game.id, self.id, 2, Game::ROLE::DEFENSE)
      player2.notify_new_round(game.id, self.id, 1, Game::ROLE::OFFENSE)
    end    
    
    
  end
      
    
end