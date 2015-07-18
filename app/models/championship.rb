class Championship < ActiveRecord::Base
  has_many :games
  belongs_to :referee
  has_many :players
  validates_presence_of :title
  validates_numericality_of :number_of_players
  validates :number_of_players, :inclusion => { :in => 2..16, :message => "The number of players can be between 2..16" }
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
    if self.players.size.odd?
      self.bye_player_identity = self.players.first.identity
      self.players[1..self.players.size-1].each_slice(2) { |opponents|  Game.create_game(self.id, opponents[0], opponents[1])}    
    else
      self.players.each_slice(2) { |opponents|  Game.create_game(self.id, opponents[0], opponents[1])}    
    end  
    
    self.status = Status::INPROGRESS
    self.save    
  end

  def number_of_players_joined
    self.players.size
  end

  
  
  def championship_finished?(round_number, completed_games_count)
    power = (Math.log(number_of_players) / Math.log(2)).ceil
    round_number == power - 1 && completed_games_count == 1 && !bye_player_exists?
  end

  def game_completed        
    round_number = self.games.last.round            
    completed_games_count = Game.games_count(self.id, round_number)    
    completed_games = Game.completed_games(self.id, round_number)   

    return self.close_championship(completed_games.first.winner) if championship_finished?(round_number, completed_games_count) 
    
    return Game.create_new_games(completed_games, round_number) if completed_games_count.even? && self.bye_player_identity.nil?
        
    if bye_player_exists?

      previous_round_game = get_bye_player_previous_game
      self.update_column(:bye_player_identity, nil)

      if completed_games_count.even?
        self.set_bye_player_identity(round_number)      
        completed_games = completed_games.select{|cg| cg.winner != bye_player_identity}      
      end      
      new_set = completed_games.push(previous_round_game)
      Game.create_new_games(new_set, round_number)
    else
      self.set_bye_player_identity(round_number)      
      new_set = completed_games.select{|cg| cg.winner != bye_player_identity}      
      Game.create_new_games(new_set, round_number)    
    end        
        
    
  end

  def close_championship(winner_identity)
    self.winner = winner_identity
    self.status = Status::CLOSED
    self.save
  end

  def bye_player_exists?
    !self.bye_player_identity.nil?
  end

  def set_bye_player_identity(round_number)
    game_bye_player_identity = Game.bye_player(self.id, round_number)          
    self.bye_player_identity = game_bye_player_identity
    self.save
  end

  def get_bye_player_previous_game
    previous_round_game = self.games.where("winner = ?", self.bye_player_identity).last       
    if previous_round_game.nil?
      previous_round_game = Game.new(championship_id: self.id, player1_identity: self.bye_player_identity, winner: self.bye_player_identity)
    end  
    previous_round_game 
  end

end