class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table "categories", :force => true do |t|
      t.string  "french",         :limit => 200
      t.string  "english",        :limit => 200
      t.string  "code",           :limit => 200
      t.string  "classification", :limit => 100
      t.string  "icon",           :limit => 200
      t.boolean "visible"
    end
   add_column :categories, :numeric_code, :integer
   add_column :categories, :total_locations, :integer
   add_column :categories, :new_locations, :integer
   add_column :categories, :invalid_locations, :integer
   add_column :categories, :corrected_locations, :integer
   add_column :categories, :audited_locations, :integer
   add_column :categories, :field_checked_locations, :integer
   add_column :categories, :navitel_french, :string
   add_column :categories, :navitel_english, :string
   add_column :categories, :navitel_code, :string
   add_column :categories, :navteq_french, :string
   add_column :categories, :navteq_english, :string
   add_column :categories, :navteq_code, :string
   add_column :categories, :garmin_french, :string
   add_column :categories, :garmin_english, :string
  end

  def self.down
    drop_table :categories
  end
end
