class CreateUserBooks < ActiveRecord::Migration
  def change
    create_table :user_books do |t|
      t.integer :user_id, :null => false
      t.integer :book_id
      t.integer :status, :default => 0
      t.string :url, :null => false
      t.decimal :lat, :null => false, :precision => 10, :scale => 6
      t.decimal :long, :null => false, :precision => 10, :scale => 6
      t.timestamps :null => false
    end
  end
end
