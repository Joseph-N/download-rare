class AddDownloadCountToEpisodes < ActiveRecord::Migration
  def change
    add_column :episodes, :download_count, :integer
  end
end
