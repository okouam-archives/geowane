class CreateCategoriesTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:categories)
      create_table :categories, :force => true do |t|
        t.string :french, :limit => 200, :null => false
        t.string :english, :limit => 200, :null => false
        t.string :shape, :null => false
        t.string :code, :limit => 200
        t.string :icon, :limit => 200
        t.boolean :is_internal, :default => false
        t.integer :numeric_code, :default => 0
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :categories if table_exists?(:categories)
  end

end
