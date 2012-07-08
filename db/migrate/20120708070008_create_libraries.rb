class CreateLibraries < ActiveRecord::Migration
  def change
    create_table :libraries do |t|
      t.string :name
      t.string :title
      t.string :author
      t.string :publisher
      t.integer :year

      t.timestamps
    end
  end
end
