class CreateCommunes < ActiveRecord::Migration

  def self.up
    create_table :communes do |t|
      t.string :name
    end
    add_column :communes, :feature, :geometry, :limit => nil, :srid => 4326
    add_index "communes", ["feature"], :name => "idx_communes_feature", :spatial => true
  end

  def self.down
    drop_table :communes
  end

end
