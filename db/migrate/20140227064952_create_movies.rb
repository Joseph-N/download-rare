class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
    	t.string :title
		t.integer :tmdb_id, :unique => true
		t.string :poster
		t.string :backdrop
		t.date :release_date
    t.string :download_link

		t.timestamps
    end
    add_index :movies, :tmdb_id, :unique => true
  end
end
