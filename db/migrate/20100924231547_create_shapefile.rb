class CreateShapefile < ActiveRecord::Migration
  def self.up
    create_table :shapefiles do |t|
      t.string :filename
      t.string :locations
    end
  end

  def self.down
    drop_table :shapefiles
  end
end
