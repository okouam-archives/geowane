class AddCountersToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :total_locations, :integer
    add_column :categories, :new_locations, :integer
    add_column :categories, :invalid_locations, :integer
    add_column :categories, :corrected_locations, :integer
    add_column :categories, :audited_locations, :integer
    add_column :categories, :field_checked_locations, :integer
  end

  def self.down
  end
end
