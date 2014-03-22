class AddBaseUrlToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :base_url, :string
  end
end
