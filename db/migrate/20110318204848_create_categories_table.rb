class CreateCategoriesTable < ActiveRecord::Migration
  def change
    create_table :categories do |t|
      t.string :french, :limit => 200, :null => false
      t.string :english, :limit => 200, :null => false
      t.string :code, :limit => 200
      t.boolean :is_hidden, :default => false
      t.boolean :is_landmark, :default => false
      t.timestamps
    end
    add_index :idx_categories, [:is_landmark], :name => 'idx_categories_is_landmark'
    add_index :idx_categories, [:is_hidden], :name => 'idx_categories_is_hidden'
  end
end
