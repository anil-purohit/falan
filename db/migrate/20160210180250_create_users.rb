class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|

      t.string :email_id, :null => false
      t.string :first_name
      t.string :last_name
      t.integer :status, :default => 0
      t.integer :signup_medium, :default => 0
      t.string :signup_id
      t.string :access_token
      t.timestamps :null => false
    end
  end
end
