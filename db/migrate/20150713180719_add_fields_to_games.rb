class AddFieldsToGames < ActiveRecord::Migration
  def change
    add_column :games, :player1_identity, :string
    add_column :games, :player2_identity, :string
    add_column :games, :order_of_play, :integer
  end
end
