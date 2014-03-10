class CreateCaches < ActiveRecord::Migration
  def change
    create_table :caches do |t|
      t.string :title
      t.binary :content
      t.text :description

      t.timestamps
    end
  end
end
