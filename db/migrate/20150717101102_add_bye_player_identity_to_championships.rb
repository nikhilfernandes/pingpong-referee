class AddByePlayerIdentityToChampionships < ActiveRecord::Migration
  def change
    add_column :championships, :bye_player_identity, :string
  end
end
