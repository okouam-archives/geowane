class AddSygicToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :sygic_french, :string
    add_column :categories, :sygic_english, :string
    add_column :categories, :sygic_code, :string
  end

  def self.down
  end
end
