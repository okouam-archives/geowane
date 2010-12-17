class AddLongNameToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :long_name, :string
  end

  def self.down
    remove_column :locations, :long_name
  end
end
