class AddApprovedFieldToEpisode < ActiveRecord::Migration
  def change
    add_column :episodes, :approved, :boolean, :default => false
  end
end
