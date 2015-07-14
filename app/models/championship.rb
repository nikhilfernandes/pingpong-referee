
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
        order_of_player1: 1, order_of_player2: 2, status: Game::STATUS::STARTED)      
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


end