class CreateBooks < ActiveRecord::Migration
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :publisher
      t.integer :year
      t.belongs_to :library

      t.timestamps
    end
    add_index :books, :library_id
  end
end
