class CreateRegions < ActiveRecord::Migration

  def self.up
    create_table :regions do |t|
      t.string :name
    end
    add_column :regions, :feature, :geometry, :limit => nil, :srid => 4326
    add_index "regions", ["feature"], :name => "idx_regions_feature", :spatial => true
  end

  def self.down
    drop_table :regions
  end

end
