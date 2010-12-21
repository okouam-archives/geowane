class AddImportIdToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :import_id, :integer
  end

  def self.down
  end
end
