class CreateSelectionsTable < ActiveRecord::Migration

  def self.up
    create_table :selections do |t|
      t.string :name, :null => false
      t.decimal :longitude, :null => false
      t.decimal :latitude, :null => false
      t.string :comment
      t.integer :original_id
      t.references :import, :null => false
      t.timestamps
    end
    add_index :selections, ["original_id"], :name => "idx_selections_original_id"
    add_index :selections, ["import_id"], :name => "idx_selections_import_id"
  end

  def self.down
    drop_table :selections
  end

end
