class AddLastPlayedByToRounds < ActiveRecord::Migration
  def change
    add_column :rounds, :last_played_by, :string
  end
end
