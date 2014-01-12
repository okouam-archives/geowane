class CreateSelectionsTable < ActiveRecord::Migration
  def change
    create_table :selections do |t|
      t.string :name, :null => false
      t.decimal :longitude, :null => false
      t.decimal :latitude, :null => false
      t.string :comment
      t.integer :original_id
      t.references :import, :null => false
      t.timestamps
    end
    add_index :selections, %w(original_id), :name => 'idx_selections_original_id'
    add_index :selections, %w(import_id), :name => 'idx_selections_import_id'
  end
end
