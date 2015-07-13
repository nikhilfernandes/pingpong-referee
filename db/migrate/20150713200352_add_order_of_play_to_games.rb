class AddOrderOfPlayToGames < ActiveRecord::Migration
  def change
    remove_column :games, :order_of_play
    add_column :games, :order_of_player1, :integer
    add_column :games, :order_of_player2, :integer
    
  end
end
