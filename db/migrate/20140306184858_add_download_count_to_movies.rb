class AddDownloadCountToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :download_count, :integer
  end
end
