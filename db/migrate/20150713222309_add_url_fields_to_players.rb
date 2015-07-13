class AddUrlFieldsToPlayers < ActiveRecord::Migration
  def change
    remove_column :players, :url
    remove_column :players, :role
    add_column :players, :host, :string
    add_column :players, :port, :string
    add_column :players, :path, :string
  end
end
