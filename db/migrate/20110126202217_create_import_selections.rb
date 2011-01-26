class CreateImportSelections < ActiveRecord::Migration
  def self.up
    create_table :selections do |t|
      t.string :name, :null => false
      t.decimal :longitude
      t.decimal :latitude
      t.string :comment
      t.integer :original_id
      t.references :import
      t.timestamps
    end
  end

  def self.down
    drop_table :selections
  end
end
