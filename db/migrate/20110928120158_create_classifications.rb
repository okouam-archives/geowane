class CreateClassifications < ActiveRecord::Migration
  def change
    create_table :classifications do |t|
      t.timestamps
      t.string :name
    end
  end
end
