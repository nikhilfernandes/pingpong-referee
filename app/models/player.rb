class Player < ActiveRecord::Base
  belongs_to :championship
  before_create :ensure_authentication_token

  validates_presence_of :name, :identity, :defence_length, :host, :port, :path
  validates_numericality_of :defence_length

  validate :number_of_players
  validate :duplicate_entry

  after_create :create_games, if: :eight_players_have_joined?

  

  def number_of_players    
    errors.add(:championship, "The championship has exceeded the number of players") if self.championship.reload.players.size == 8
  end

  def duplicate_entry    
    errors.add(:identity, "The player has already joined the game") if championship.players.pluck(:identity).include?(self.identity)    
  end

  def ensure_authentication_token    
    self.auth_token = generate_auth_token    
  end

  def generate_auth_token
    loop do
      token = Digest::SHA1.hexdigest(Time.now.strftime("%Y%m%d%H%M%S%L").to_s)    
      break token unless Player.where(auth_token: token).first
    end    
  end

  def eight_players_have_joined?
    self.championship.players.size == 8
  end

  def create_games
    self.championship.create_games
  end


end