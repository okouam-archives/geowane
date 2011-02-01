class AddAdministrativeUnitsToLocations < ActiveRecord::Migration
  def self.up
      add_column :locations, :administrative_unit_0, :integer
      add_column :locations, :administrative_unit_1, :integer
      add_column :locations, :administrative_unit_2, :integer
      add_column :locations, :administrative_unit_3, :integer
      add_column :locations, :administrative_unit_4, :integer
  end

  def self.down
  end
end
