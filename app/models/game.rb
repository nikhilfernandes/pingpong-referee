class Game < ActiveRecord::Base
  belongs_to :championship
  has_many :rounds
  after_create :notify_players
  after_create :create_round
  
  

  module STATUS
    STARTED = "started"
    COMPLETED = "completed"
  end

  module ROLE
    OFFENSE = "offense"
    DEFENSE = "defense"
  end


  def update_score(winner_identity)        
    self.player1_score = (self.player1_score || 0) + 1 if winner_identity == self.player1_identity
    self.player2_score = (self.player2_score || 0) + 1 if winner_identity == self.player2_identity
    if game_over?
      self.status = STATUS::COMPLETED
      self.winner = winner_player
      self.save                     
      self.championship.game_completed if all_league_games_over?      
    else      
      self.save
      create_round
    end

    
  end

  

  def all_league_games_over?
    self.championship.games.where("status = ?", "started").count == 0
  end

  def game_over?
    self.player1_score == 5 || self.player2_score == 5
  end

  def winner_player
    return self.player1_identity if self.player1_score == 5
    return self.player2_identity if self.player2_score == 5
    return nil
  end

  def loser
    return self.player1_identity if self.player1_score != 5
    return self.player2_identity if self.player2_score != 5
    return nil
  end

  def self.games_count(championship_id, round_number)
    championship = Championship.find(championship_id)
    championship.games.where("status = ? and round = ?", Game::STATUS::COMPLETED, round_number).count
  end

  def self.completed_games(championship_id, round_number)
    championship = Championship.find(championship_id)
    championship.games.where("status = ? and round = ?", Game::STATUS::COMPLETED, round_number)
  end

  def self.bye_player(championship_id, round_number)
    compl_games = completed_games(championship_id, round_number)
    bye_player_identity = compl_games.first.player1_score > compl_games.first.player2_score ? compl_games.first.player1_identity : compl_games.first.player2_identity
    bye_player_score  = compl_games.first.player1_score > compl_games.first.player2_score ? compl_games.first.player1_score : compl_games.first.player2_score
    compl_games.each do |com_game|
      if ((com_game.player1_score > com_game.player2_score) && (com_game.player1_score > bye_player_score))
      bye_player_identity = com_game.player1_identity  
      bye_player_score = com_game.player1_score  
      end
      if ((com_game.player1_score < com_game.player2_score) && (com_game.player2_score > bye_player_score))
        bye_player_identity = com_game.player2_identity  
        bye_player_score = com_game.player2_score 
      end
    end
    bye_player_identity
  end

  def self.create_new_games(completed_games, round_number)
    championship = completed_games.first.championship unless completed_games.empty?
    completed_games.each_slice(2) do |completed_game_2|
      player1 = championship.players.find_by_identity(completed_game_2[0].winner)
      player2 = championship.players.find_by_identity(completed_game_2[1].winner)        
      Game.create_game(championship.id, player1, player2, (round_number+1))

    end
  end

  def self.create_game(championship_id, player1, player2, round=0)
    championship = Championship.find(championship_id)
    championship.games.create(player1_identity: player1.identity, player2_identity: player2.identity, 
      order_of_player1: 1, order_of_player2: 2, status: Game::STATUS::STARTED, round: round)          
  end

  def create_round
    turn = winner || self.player1_identity    
    self.rounds.create(number: 0, turn: turn)          
  end

  def notify_players
    player1 = self.championship.players.find_by_identity(self.player1_identity)
    player2 = self.championship.players.find_by_identity(self.player2_identity)
    player1.notify_new_game(self.id, player2.identity)
    player2.notify_new_game(self.id, player1.identity)
  end

  def notify_players_game_outcome
    winner_player = self.championship.players.find_by_identity(self.winner)
    loser_player = self.championship.players.find_by_identity(self.loser)
    winner_player.notify_game_outcome(self.id, Round::Outcome::WON)
    loser_player.notify_game_outcome(self.id, Round::Outcome::LOST)
  end

end