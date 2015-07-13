class CreatePlayers < ActiveRecord::Migration
  def change
    create_table :players do |t|
      t.integer :championship_id
      t.string :identity
      t.string :auth_token
      t.string :name
      t.integer :defence_length
    end
  end
end
