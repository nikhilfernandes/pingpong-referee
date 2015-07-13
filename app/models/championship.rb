class Championship < ActiveRecord::Base
  has_many :games
  belongs_to :referee
  has_many :players
  validates_presence_of :title

  def create_games
    index = 1
    self.players.each_slice(2) do |opponents| 
      game = self.games.create(player1_identity: opponents[0].identity, player2_identity: opponents[1].identity, order_of_play: index)      
      game.rounds.create(number: 0, turn: opponents[0].identity)
      index = index+1
    end
    
  end


end