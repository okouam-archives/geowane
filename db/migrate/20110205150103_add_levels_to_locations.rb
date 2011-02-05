class AddLevelsToLocations < ActiveRecord::Migration

  def self.up
    add_column :locations, :level_0, :integer
    add_column :locations, :level_1, :integer
    add_column :locations, :level_2, :integer
    add_column :locations, :level_3, :integer
    add_column :locations, :level_4, :integer
  end

  def self.down
  end

end
