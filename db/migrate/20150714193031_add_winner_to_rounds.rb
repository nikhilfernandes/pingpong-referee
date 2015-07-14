class AddWinnerToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :winner, :string
  end
end
