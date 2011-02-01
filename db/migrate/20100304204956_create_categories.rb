class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table "categories", :force => true do |t|
      t.string  "french",         :limit => 200
      t.string  "english",        :limit => 200
      t.string  "code",           :limit => 200
      t.string  "classification", :limit => 100
      t.string  "icon",           :limit => 200
      t.boolean "visible"
      t.integer  :numeric_code, :default => 0
      t.integer :total_locations, :default => 0
      t.integer :new_locations, :default => 0
      t.integer :invalid_locations, :default => 0
      t.integer :corrected_locations, :default => 0
      t.integer :audited_locations, :default => 0
      t.integer :field_checked_locations, :default => 0
      t.string :navitel_french, :string
      t.string :navitel_english, :string
      t.string :navitel_code, :string
      t.string :navteq_french, :string
      t.string :navteq_english, :string
      t.string :navteq_code, :string
      t.string :garmin_french, :string
      t.string :garmin_english, :string
    end
    add_column :categories, :sygic_french, :string
    add_column :categories, :sygic_english, :string
    add_column :categories, :sygic_code, :string
    add_column :categories, :tags_count, :integer, :default => 0
    add_column :categories, :level, :integer, :default => 0, :null => false
    add_column :categories, :end_level, :integer, :default => 0, :null => false
  end

  def self.down
    drop_table :categories
  end
end
