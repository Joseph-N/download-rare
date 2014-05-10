class AddSubtitlesToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :subtitle_url, :string
  end
end
