class CreateTableGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :championship_id
    end
  end
end
