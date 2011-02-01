class AddLevelsToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :level, :integer, :default => 0, :null => false
    add_column :categories, :end_level, :integer, :default => 0, :null => false
  end

  def self.down
  end
end
