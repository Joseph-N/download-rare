class CreateEpisodes < ActiveRecord::Migration
  def change
    create_table :episodes do |t|
      t.integer :episode_number
      t.string :download_link
      t.references :season, index: true

      t.timestamps
    end
    add_index :episodes, :episode_number
  end
end
