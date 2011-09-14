class CreateMappingsTable < ActiveRecord::Migration
  def change
    create_table :mappings, :force => true do |t|
      t.timestamps
      t.references :category, :foreign_key => true, :dependent => :delete, :null => false
      t.references :partner_category, :foreign_key => true, :dependent => :delete, :null => false
    end
    add_index :mappings, [:category_id], :name => "idx_mappings_on_category_id"
    add_index :mappings, [:partner_category_id], :name => "idx_mappings_on_partner_category_id"
  end
end
