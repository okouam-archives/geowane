class CreateCategoriesTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:categories)
      create_table :categories, :force => true do |t|
        t.string :french, :limit => 200
        t.string :english, :limit => 200
        t.string :code, :limit => 200
        t.string :classification, :limit => 100
        t.string :icon, :limit => 200
        t.boolean :visible, :default => true
        t.integer :numeric_code, :default => 0
        t.integer :total_locations, :default => 0
        t.integer :new_locations, :default => 0
        t.integer :invalid_locations, :default => 0
        t.integer :corrected_locations, :default => 0
        t.integer :audited_locations, :default => 0
        t.integer :field_checked_locations, :default => 0
        t.string :navitel_french
        t.string :navitel_english
        t.string :navitel_code
        t.string :navteq_french
        t.string :navteq_english
        t.string :navteq_code
        t.string :garmin_french
        t.string :garmin_english
        t.string :sygic_french
        t.string :sygic_english
        t.string :sygic_code
        t.integer :level, :default => 0, :null => false
        t.integer :end_level, :default => 0, :null => false
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :categories if table_exists?(:categories)
  end

end
