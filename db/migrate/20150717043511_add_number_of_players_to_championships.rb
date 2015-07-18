class AddNumberOfPlayersToChampionships < ActiveRecord::Migration

  def change
    add_column :championships, :number_of_players, :integer
  end
  
end
