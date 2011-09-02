class CreateImportsTable < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.integer :locations_count, :default => 0
      t.string :input_file_name
      t.string :input_content_type
      t.integer :input_file_size
      t.datetime :input_updated_at
      t.enum :import_format
      t.references :user, :foreign_key => true
      t.timestamps
    end
  end
end
