class AddSlugToMoviesAndShows < ActiveRecord::Migration
  def change
    add_column :movies, :slug, :string
    add_column :tv_shows, :slug, :string
    add_index :movies, :slug, unique: true
    add_index :tv_shows, :slug, unique: true 
  end
end
