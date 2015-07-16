
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
    self.players.each_slice(2) do |opponents| 
      game = self.games.create(player1_identity: opponents[0].identity, player2_identity: opponents[1].identity, 
        order_of_player1: 1, order_of_player2: 2, status: Game::STATUS::STARTED, round: 0)      
      game.rounds.create(number: 0, turn: opponents[0].identity)      
      HttpRequest.post(opponents[0].host, opponents[0].port, opponents[0].path, {game: {championship_id: self.id, identity: game.id, oponent_identity: opponents[1].identity, order_of_play: 1, role: Game::ROLE::OFFENSE,  status: Game::STATUS::STARTED}}, opponents[0].auth_token)
      HttpRequest.post(opponents[1].host, opponents[1].port, opponents[1].path, {game: {championship_id: self.id, identity: game.id, oponent_identity: opponents[0].identity, order_of_play: 2, role: Game::ROLE::DEFENSE, status: Game::STATUS::STARTED}}, opponents[1].auth_token)
    end
    self.status = Status::INPROGRESS
    self.save
    
  end

  def number_of_players_joined
    self.players.size
  end

  def round_completed
    round_number = self.games.last.round
    completed_games_count = self.games.where("status = ? and round = ?", Game::STATUS::COMPLETED, round_number).count
    completed_games= self.games.where("status = ? and round = ?", Game::STATUS::COMPLETED, round_number)
    
    if ((round_number == 0 && completed_games_count == 8)||(round_number == 1 && completed_games_count == 4))
      completed_games.each_slice(2) do |completed_game_2|
      opponent1 = completed_game_2[0].winner
      opponent2 = completed_game_2[1].winner

      game = self.games.create(player1_identity: opponent1.identity, player2_identity: opponent2.identity, 
        order_of_player1: 1, order_of_player2: 2, status: Game::STATUS::STARTED, round: round_number+1)   

      game.rounds.create(number: 0, turn: opponent1.identity)      
      HttpRequest.post(opponent1.host, opponent1.port, opponent1.path, {game: {championship_id: self.id, identity: game.id, oponent_identity: opponent2.identity, order_of_play: 1, role: Game::ROLE::OFFENSE,  status: Game::STATUS::STARTED}}, opponent1.auth_token)
      HttpRequest.post(opponent2.host, opponent2.port, opponent2.path, {game: {championship_id: self.id, identity: game.id, oponent_identity: opponent2.identity, order_of_play: 2, role: Game::ROLE::DEFENSE, status: Game::STATUS::STARTED}}, opponent2.auth_token)
    end
    end
    if round_number == 2 && completed_games_count == 2

    end
  end

  


end