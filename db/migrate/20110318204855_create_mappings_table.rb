class CreateMappingsTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:mappings)
      create_table :mappings, :force => true do |t|
        t.timestamps
        t.string :name
        t.string :value
        t.references :category, :foreign_key => true, :dependent => :delete
        t.references :partner, :foreign_key => true, :dependent => :delete
      end
    end
  end

  def self.down
    drop_table :mappings if table_exists?(:mappings)
  end

end
