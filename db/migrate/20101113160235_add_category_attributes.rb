class AddCategoryAttributes < ActiveRecord::Migration
  def self.up
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
  end
end
