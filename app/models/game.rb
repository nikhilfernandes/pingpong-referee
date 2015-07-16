class Game < ActiveRecord::Base
  belongs_to :championship
  has_many :rounds
  after_create :create_round

  module STATUS
    STARTED = "started"
    COMPLETED = "completed"
  end

  module ROLE
    OFFENSE = "offense"
    DEFENSE = "defense"
  end


  def update_score(winner_identity)        
    self.player1_score = (self.player1_score || 0) + 1 if winner_identity == self.player1_identity
    self.player2_score = (self.player2_score || 0) + 1 if winner_identity == self.player2_identity
    self.save
    
    if game_over?
      self.status = STATUS::COMPLETED
      self.save             
      self.championship.game_completed
    else      
      create_round
    end
  end

  def game_over?
    self.player1_score == 5 || self.player2_score == 5
  end

  def winner
    return self.player1_identity if self.player1_score == 5
    return self.player2_identity if self.player2_score == 5
    return nil
  end

  def self.create_game(championship_id, player1, player2, round=0)
    championship = Championship.find(championship_id)
    championship.games.create!(player1_identity: player1.identity, player2_identity: player2.identity, 
      order_of_player1: 1, order_of_player2: 2, status: Game::STATUS::STARTED, round: round)          
  end

  def create_round
    turn = winner || self.player1_identity    
    self.rounds.create(number: 0, turn: turn)          
  end

end