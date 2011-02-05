class CreateRegions < ActiveRecord::Migration

  def self.up
    create_table :regions do |t|
      t.string :name
    end
    add_column :regions, :uncategorized_locations, :integer
    add_column :regions, :total_locations, :integer
    add_column :regions, :new_locations, :integer
    add_column :regions, :invalid_locations, :integer
    add_column :regions, :corrected_locations, :integer
    add_column :regions, :audited_locations, :integer
    add_column :regions, :field_checked_locations, :integer
    add_column :regions, :feature, :geometry, :limit => nil, :srid => 4326
    add_index "regions", ["feature"], :name => "idx_regions_feature", :spatial => true
  end

  def self.down
    drop_table :regions
  end

end
