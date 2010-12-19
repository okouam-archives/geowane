class DropCategoryInLocations < ActiveRecord::Migration
  def self.up
    remove_column :locations, :category_id
  end

  def self.down
  end
end
