class Game < ActiveRecord::Base
  belongs_to :championship
  has_many :rounds

  module STATUS
    STARTED = "started"
    COMPLETED = "completed"
  end

  module ROLE
    OFFENSE = "offense"
    DEFENSE = "defense"
  end


  def update_score(winner)    
    if winner == self.player1_identity
      self.player1_score = (self.player1_score || 0) + 1
    elsif winner == self.player2_identity
      self.player2_score = (self.player2_score || 0) + 1
    end
    self.save

    if self.player1_score == 5 || self.player2_score == 5
      self.status = STATUS::COMPLETED
      self.save
    end

  end

  def winner
    return self.championship.players.where("identity = ?", self.player1_identity) if self.player1_score == 5
    return self.championship.players.where("identity = ?", self.player2_identity) if self.player2_score == 5
    return nil
  end




end