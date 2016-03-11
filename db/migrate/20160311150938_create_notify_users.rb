class CreateNotifyUsers < ActiveRecord::Migration
  def change
    create_table :notify_users do |t|
      t.string :email_id, :null => false
      t.timestamps :null => false
    end
  end
end
