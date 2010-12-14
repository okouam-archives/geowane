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
  end

  def self.down
    drop_table :categories
  end
end
