require "net/http"
require "uri"

class Championship < ActiveRecord::Base
  has_many :games
  belongs_to :referee
  has_many :players
  validates_presence_of :title
  before_create :set_status

  module Status
    OPEN = "open"
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
      HttpRequest.post(opponents[0], opponents[0].port, opponents[0].path, {game_id: game.id, order_of_play: 1, status: Game::STATUS::STARTED}, opponents[0].auth_token)
      HttpRequest.post(opponents[1], opponents[1].port, opponents[1].path, {game_id: game.id, order_of_play: 2, status: Game::STATUS::STARTED}, opponents[1].auth_token)

    end

    self.status = Status::CLOSED
    self.save
    
  end


end