class Championship < ActiveRecord::Base
  has_many :games
  belongs_to :referee
  has_many :players



  validates_presence_of :title
  validate :number_of_players

  def number_of_players
    errors.add(:players, "The championship has exceeded the number of players") if players.size > 8
  end

end