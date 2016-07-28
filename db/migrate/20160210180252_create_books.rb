class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|

      t.string :title
      t.string :author
      t.string :publication
      t.string :tags
      t.string :isbn
      t.string :url
      t.timestamps :null => false
    end
    add_index :books, :title
    add_index :books, :author
    add_index :books, :isbn
  end
end
