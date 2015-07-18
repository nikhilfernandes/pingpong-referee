class Player < ActiveRecord::Base
  belongs_to :championship
  before_create :ensure_authentication_token

  validates_presence_of :name, :identity, :defence_length, :host, :port, :path
  validates_numericality_of :defence_length

  validate :number_of_players
  validate :duplicate_entry, :on => :create

  before_create :update_players_info
  after_create :create_games, if: :all_players_have_joined?
  

  

  def number_of_players    
    errors.add(:identity, "The championship has exceeded the number of players") if self.championship.reload.players.size > championship.number_of_players
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

  def all_players_have_joined?
    self.championship.reload    
    self.championship.players.size == championship.number_of_players
  end

  def create_games
    self.championship.create_games
  end

  def update_players_info
    self.championship.reload
    self.championship.players.each do |player|       
    Resque.enqueue(AsyncJob, {host: self.host, port: self.port, path: "/championships/#{championship.id}", method: "put", payload: {championship: {status: self.championship.status, num_players_joined: self.championship.players.size+1}}, auth_token: self.auth_token})    
    end
  end

  def notify_new_game(game_id, opponent_identity)
    Resque.enqueue(AsyncJob, {host: self.host, port: self.port, path: "/championships/#{championship.id}/games", method: "post", payload: {game: {game_identity: game_id ,oponent_identity: opponent_identity, status: Game::STATUS::STARTED}}, auth_token: self.auth_token})
    # HttpRequest.post(self.host, self.port, "/championships/#{championship.id}/games", {game: {game_identity: game_id ,oponent_identity: opponent_identity, status: Game::STATUS::STARTED}}, self.auth_token)
  end

  def notify_game_outcome(game_id, outcome)
    Resque.enqueue(AsyncJob, {host: self.host, port: self.port, path: "/championships/#{championship.id}/games/#{game_id}", payload: {game: {game_identity: game_id ,outcome: outcome, status: Game::STATUS::COMPLETED}}, auth_token: self.auth_token})
    # HttpRequest.put(self.host, self.port, "/championships/#{championship.id}/games/#{game_id}", {game: {game_identity: game_id ,outcome: outcome, status: Game::STATUS::COMPLETED}}, self.auth_token)
  end

  def notify_new_round(game_id, round_id, order_of_play, role)    
    Resque.enqueue(AsyncJob, {host: self.host, port: self.port, path: "/championships/#{championship.id}/games/#{game_id}/rounds", method: "post", payload: {round: {round_identity: round_id , order_of_play: order_of_play, role: role}}, auth_token: self.auth_token})
    # HttpRequest.post(self.host, self.port, "/championships/#{championship.id}/games/#{game_id}/rounds", {round: {round_identity: round_id , order_of_play: order_of_play, role: role}}, self.auth_token)
  end

  def notify_player_of_outcome_round(game_id, round_id)    
    Resque.enqueue(AsyncJob, {host: self.host, port: self.port, path: "/championships/#{championship.id}/games/#{game_id}/rounds/#{round_id}", method: "put", payload: {round: {outcome: outcome}}, auth_token: self.auth_token})
    # HttpRequest.put(self.host, self.port, "/championships/#{championship.id}/games/#{game_id}/rounds/#{round_id}", {round: {role: role, outcome: outcome}}, self.auth_token)
  end

end