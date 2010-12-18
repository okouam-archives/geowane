class CreateLevels < ActiveRecord::Migration

  def self.up

    create_table :level0 do |t|
      t.string :name
      t.string :level1
      t.string :level2
      t.string :level3
      t.string :level4
      t.string :level5
    end
    add_column :level0, :feature, :geometry, :limit => nil, :srid => 4326
    add_index :level0, ["feature"], :name => "idx_level0_feature", :spatial => true

    create_table :level1 do |t|
      t.string :name
    end
    add_column :level1, :feature, :geometry, :limit => nil, :srid => 4326
    add_index :level1, ["feature"], :name => "idx_level1_feature", :spatial => true

    create_table :level2 do |t|
      t.string :name
    end
    add_column :level2, :feature, :geometry, :limit => nil, :srid => 4326
    add_index :level2, ["feature"], :name => "idx_level2_feature", :spatial => true

    create_table :level3 do |t|
      t.string :name
    end
    add_column :level3, :feature, :geometry, :limit => nil, :srid => 4326
    add_index :level3, ["feature"], :name => "idx_level3_feature", :spatial => true

    create_table :level4 do |t|
      t.string :name
    end
    add_column :level4, :feature, :geometry, :limit => nil, :srid => 4326
    add_index :level4, ["feature"], :name => "idx_level4_feature", :spatial => true

    create_table :level5 do |t|
      t.string :name
    end
    add_column :level5, :feature, :geometry, :limit => nil, :srid => 4326
    add_index :level5, ["feature"], :name => "idx_level5_feature", :spatial => true

  end

 def self.down
   drop_table :level0
   drop_table :level1
   drop_table :level2
   drop_table :level3
   drop_table :level4
   drop_table :level5
 end

end
