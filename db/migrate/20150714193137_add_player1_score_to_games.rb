class AddPlayer1ScoreToGames < ActiveRecord::Migration
  def change
    add_column :games, :player1_score, :integer
    add_column :games, :player2_score, :integer
  end
end
