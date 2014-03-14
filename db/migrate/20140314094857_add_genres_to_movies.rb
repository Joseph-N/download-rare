class AddGenresToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :genres, :string, array: true
  end
end
