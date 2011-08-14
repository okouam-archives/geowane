class CreateMappingsTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:mappings)
      create_table :mappings, :force => true do |t|
        t.timestamps
        t.references :category, :foreign_key => true, :dependent => :delete, :null => false
        t.references :classification, :foreign_key => true, :dependent => :delete, :null => false
      end
      add_index :mappings, [:category_id], :name => "idx_mappings_on_category_id"
      add_index :mappings, [:classification_id], :name => "idx_mappings_on_classification_id"
    end
  end

  def self.down
    drop_table :mappings if table_exists?(:mappings)
  end

end
