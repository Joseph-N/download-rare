class AddSimilarMoviesToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :similar_movies, :string, array: true
  end
end
