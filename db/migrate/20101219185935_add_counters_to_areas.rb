class AddCountersToAreas < ActiveRecord::Migration
  def self.up
    add_column :countries, :uncategorized_locations, :integer
    add_column :countries, :locations, :integer
    add_column :countries, :new_locations, :integer
    add_column :countries, :invalid_locations, :integer
    add_column :countries, :corrected_locations, :integer
    add_column :countries, :audited_locations, :integer
    add_column :countries, :field_checked_locations, :integer
    add_column :regions, :uncategorized_locations, :integer
    add_column :regions, :locations, :integer
    add_column :regions, :new_locations, :integer
    add_column :regions, :invalid_locations, :integer
    add_column :regions, :corrected_locations, :integer
    add_column :regions, :audited_locations, :integer
    add_column :regions, :field_checked_locations, :integer
    add_column :communes, :uncategorized_locations, :integer
    add_column :communes, :locations, :integer
    add_column :communes, :new_locations, :integer
    add_column :communes, :invalid_locations, :integer
    add_column :communes, :corrected_locations, :integer
    add_column :communes, :audited_locations, :integer
    add_column :communes, :field_checked_locations, :integer
    add_column :cities, :uncategorized_locations, :integer
    add_column :cities, :locations, :integer
    add_column :cities, :new_locations, :integer
    add_column :cities, :invalid_locations, :integer
    add_column :cities, :corrected_locations, :integer
    add_column :cities, :audited_locations, :integer
    add_column :cities, :field_checked_locations, :integer
  end

  def self.down
  end
end
