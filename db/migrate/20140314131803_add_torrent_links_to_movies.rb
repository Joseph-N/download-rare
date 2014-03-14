class AddTorrentLinksToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :magnetic_link, :text
    add_column :movies, :torrent_file_link, :string
  end
end
