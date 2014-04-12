class AddIndexesToMovies < ActiveRecord::Migration
  def change
  	add_index :movies, [:imdb_rating,:genres,:release_date]
  end
end
