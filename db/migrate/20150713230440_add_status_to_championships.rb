class AddStatusToChampionships < ActiveRecord::Migration
  def change
    add_column :championships, :status, :string
  end
end
