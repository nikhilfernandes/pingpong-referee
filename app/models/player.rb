class Player < ActiveRecord::Base
  belongs_to :championship
  before_create :ensure_authentication_token

  validates_presence_of :name, :identity, :defence_length, :host, :port, :path
  validates_numericality_of :defence_length

  validate :number_of_players
  validate :duplicate_entry, :on => :create

  before_create :update_players_info
  after_create :create_games, if: :eight_players_have_joined?
  

  

  def number_of_players    
    errors.add(:identity, "The championship has exceeded the number of players") if self.championship.reload.players.size == 8
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
    self.championship.reload    
    self.championship.players.size == 8
  end

  def create_games
    self.championship.create_games
  end

  def update_players_info
    self.championship.reload
    self.championship.players.each do |player|       
      HttpRequest.put(player.host, player.port, "/championships/#{championship.id}", {championship: {status: self.championship.status, num_players_joined: self.championship.players.size+1}}, player.auth_token)      
    end
  end

  def notify_new_game(game_id, opponent_identity)
    HttpRequest.post(self.host, self.port, "/championships/#{championship.id}/games", {game: {game_identity: game_id ,oponent_identity: opponent_identity, status: Game::STATUS::STARTED}}, self.auth_token)
  end

    def notify_game_outcome(game_id, outcome)
    HttpRequest.put(self.host, self.port, "/championships/#{championship.id}/games/#{game_id}", {game: {game_identity: game_id ,outcome: outcome, status: Game::STATUS::COMPLETED}}, self.auth_token)
  end

  def notify_new_round(game_id, round_id, order_of_play, role)
    HttpRequest.post(self.host, self.port, "/championships/#{championship.id}/games/#{game_id}/rounds", {round: {round_identity: round_id , order_of_play: order_of_play, role: role}}, self.auth_token)
  end

  def notify_player_of_outcome_round(game_id, round_id, outcome)
    role = outcome == Round::Outcome::WON ? Game::ROLE::OFFENSE : Game::ROLE::DEFENSE
    HttpRequest.put(self.host, self.port, "/championships/#{championship.id}/games/#{game_id}/rounds/#{round_id}", {round: {role: role, outcome: outcome}}, self.auth_token)
  end

end