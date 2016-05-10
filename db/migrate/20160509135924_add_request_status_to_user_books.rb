class AddRequestStatusToUserBooks < ActiveRecord::Migration
  def change
    add_column :user_books, :exchange_status, :integer, :default => 0
    add_column :user_books, :current_owner_id, :integer
  end
end
