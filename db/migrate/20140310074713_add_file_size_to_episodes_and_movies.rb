class AddFileSizeToEpisodesAndMovies < ActiveRecord::Migration
  def change
  	add_column :episodes, :file_size, :integer
  	add_column :movies, :file_size, :integer
  end
end
