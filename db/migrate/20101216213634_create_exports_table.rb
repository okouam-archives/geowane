class CreateExportsTable < ActiveRecord::Migration
  def change
    create_table :exports do |t|
      t.integer :locations_count
      t.references :user, :foreign_key => true
      t.string :output_file_name
      t.string :output_content_type
      t.integer :output_file_size
      t.enum :output_format
      t.datetime :output_updated_at
      t.string :output_platform
      t.string :name
      t.string :description
      t.timestamps
    end
  end
end
