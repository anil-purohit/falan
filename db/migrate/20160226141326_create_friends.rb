class CreateFriends < ActiveRecord::Migration
  def change
    create_table :friends do |t|
      t.integer :user_id, :null => false
      t.string :signup_id, :null => false
      t.integer :friend_user_id
      t.timestamps :null => false
    end
    add_index :friends, :user_id
  end
end
