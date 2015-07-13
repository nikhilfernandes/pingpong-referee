class AddRefereeIdToChampionships < ActiveRecord::Migration
  def change
    add_column :championships, :referee_id, :integer
  end
end
