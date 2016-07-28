class CreateRequests < ActiveRecord::Migration
  def change
    create_table :requests do |t|
      t.integer :user_book_id, :null => false
      t.integer :requester_id, :null => false
      t.integer :status, :default => 0
      t.timestamps null: false
    end
    add_index :requests, [:requester_id, :user_book_id], unique: true
  end
end
