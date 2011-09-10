class CreateSearchCriteria < ActiveRecord::Migration
  def change
    create_table :search_criteria, :force => true do |t|
      t.timestamps
      t.references :search
      t.string :sort
      t.integer :classification_id
      t.string :bbox
      t.integer :import_id
      t.integer :added_by
      t.boolean :category_missing
      t.boolean :category_present
      t.integer :category_id
      t.integer :confirmed_by
      t.integer :invalidated_by
      t.integer :corrected_by
      t.integer :audited_by
      t.integer :modified_by
      t.integer :city_id
      t.string :added_on_after
      t.string :added_on_before
      t.string :name
      t.string :status
      t.integer :radius
      t.integer :level_id
      t.integer :location_level_0
      t.integer :location_level_1
      t.integer :location_level_2
      t.integer :location_level_3
      t.integer :location_level_4
      t.string :street_name
    end
  end
end
