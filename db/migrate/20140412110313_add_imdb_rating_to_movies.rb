class AddImdbRatingToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :imdb_rating, :float, :precision => 2, :scale => 1
  end
end
