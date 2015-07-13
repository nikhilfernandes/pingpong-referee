class CreateTableChampionships < ActiveRecord::Migration
  def change
    create_table :championships do |t|
      t.string :title

    end
  end
end
