class CreateBaseUrls < ActiveRecord::Migration
  def change
    create_table :base_urls do |t|
      t.string :url
      t.references :season, index: true

      t.timestamps
    end
  end
end
