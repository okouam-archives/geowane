class CreateCounterCaches < ActiveRecord::Migration

  def self.up
    add_column :categories, :tags_count, :integer, :default => 0
    add_column :locations, :tags_count, :integer, :default => 0   
  end

  def self.down
    remove_column :locations, :tags_count
    remove_column :categories, :tags_count
  end
end
