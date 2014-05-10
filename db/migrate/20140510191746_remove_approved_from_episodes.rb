class RemoveApprovedFromEpisodes < ActiveRecord::Migration
  def change
  	remove_column :episodes, :approved
  end
end
