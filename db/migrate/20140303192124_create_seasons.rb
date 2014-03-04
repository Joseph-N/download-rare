class CreateSeasons < ActiveRecord::Migration
  def change
    create_table :seasons do |t|
      t.integer :season_number
      t.references :tv_show, index: true

      t.timestamps
    end
    add_index :seasons, :season_number
  end
end
