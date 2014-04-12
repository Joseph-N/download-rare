class CreateSearches < ActiveRecord::Migration
  def change
    create_table :searches do |t|
      t.string :title
      t.string :year
      t.string :genre
      t.float :rating, :precision => 2, :scale => 1

      t.timestamps
    end
  end
end
