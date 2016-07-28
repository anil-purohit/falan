class AddLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :location, :string
    add_column :users, :lat, :decimal, :null => false, :precision => 10, :scale => 6
    add_column :users, :long, :decimal, :null => false, :precision => 10, :scale => 6
  end
end
