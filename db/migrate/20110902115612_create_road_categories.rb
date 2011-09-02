class CreateRoadCategories < ActiveRecord::Migration
  def change
    create_table :road_categories, :force => true do |t|
      t.string :name
      t.timestamps
    end
  end
end
