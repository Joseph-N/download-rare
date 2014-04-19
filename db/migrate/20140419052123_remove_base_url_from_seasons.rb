class RemoveBaseUrlFromSeasons < ActiveRecord::Migration
  def change
  remove_column :seasons, :base_url
  end
end
