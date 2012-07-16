class AddReleaseToBooks < ActiveRecord::Migration
  def change
    add_column :books, :release, :string
  end
end
