class CreateMappingsTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:mappings)
      create_table :mappings, :force => true do |t|
        t.timestamps
        t.references :category, :foreign_key => true, :dependent => :delete
        t.references :classification, :foreign_key => true, :dependent => :delete
      end
    end
  end

  def self.down
    drop_table :mappings if table_exists?(:mappings)
  end

end
