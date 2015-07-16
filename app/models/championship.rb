class Championship < ActiveRecord::Base
  has_many :games
  belongs_to :referee
  has_many :players
  validates_presence_of :title
  before_create :set_status

  module Status
    OPEN = "open"
    INPROGRESS = "inprogress"
    CLOSED = "closed"
  end

  def set_status
    self.status = Status::OPEN
  end

  def create_games    
    self.players.each_slice(2) { |opponents|  Game.create_game(self.id, opponents[0], opponents[1])}    
    self.status = Status::INPROGRESS
    self.save    
  end

  def number_of_players_joined
    self.players.size
  end

  def games_count(round_number)
    self.games.where("status = ? and round = ?", Game::STATUS::COMPLETED, round_number).count
  end

  def completed_games(round_number)
    self.games.where("status = ? and round = ?", Game::STATUS::COMPLETED, round_number)
  end

  def league_completed?(round_number, completed_games_count)
    ((round_number == 0 && completed_games_count == 4)||(round_number == 1 && completed_games_count == 2))
  end

  def championship_finished?(round_number, completed_games_count)
    round_number == 2 && completed_games_count == 1
  end

  def game_completed    
    round_number = self.games.last.round    
    completed_games_count = games_count(round_number)    
    completed_games= completed_games(round_number)    
    if league_completed?(round_number, completed_games_count)        
      completed_games.each_slice(2) do |completed_game_2|
        player1 = self.players.find_by_identity(completed_game_2[0].winner)
        player2 = self.players.find_by_identity(completed_game_2[1].winner)        
        Game.create_game(self.id, player1, player2, round_number+1)
      end
    end
    if championship_finished?(round_number, completed_games_count)
        self.winner = completed_games.first.winner
        self.status = Status::CLOSED
        self.save
    end
  end




end