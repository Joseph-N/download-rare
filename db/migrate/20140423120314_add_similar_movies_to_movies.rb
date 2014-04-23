class AddSimilarMoviesToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :similar_movies, :string, array: true
    add_index :movies, :similar_movies
  end
end
