class AddRoleToPlayers < ActiveRecord::Migration
  def change
    add_column :players, :role, :integer
  end
end
