class CreateRounds < ActiveRecord::Migration
  def change
    create_table :rounds do |t|
      t.integer :game_id
      t.integer :number
      t.string :turn
      t.integer :offensive_number
      t.column :defensive_array, :json
    end
  end
end
