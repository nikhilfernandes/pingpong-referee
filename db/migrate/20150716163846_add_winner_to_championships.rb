class AddWinnerToChampionships < ActiveRecord::Migration
  def change
    add_column :championships, :winner, :string
  end
end
