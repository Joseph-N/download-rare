class RemoveFieldsFromTables < ActiveRecord::Migration
  def change
  	remove_column :episodes, :download_link
  	remove_column :episodes, :file_size
  end
end
