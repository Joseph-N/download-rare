class CreateTvShows < ActiveRecord::Migration
  def change
    create_table :tv_shows do |t|
    	t.string :name
		t.integer :tmdb_id, :unique => true
		t.string :poster
		t.string :backdrop
		t.date :release_date

		t.timestamps
    end
    add_index :tv_shows, :tmdb_id, :unique => true
  end
end
