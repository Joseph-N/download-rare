class CreateDownloadLinks < ActiveRecord::Migration
  def change
    create_table :download_links do |t|
      t.string :url
      t.integer :file_size
      t.references :episode, index: true

      t.timestamps
    end
  end
end
