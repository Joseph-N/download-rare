class CreateDeadLinks < ActiveRecord::Migration
  def change
    create_table :dead_links do |t|
      t.string :resource_type
      t.integer :resource_id

      t.timestamps
    end
  end
end
