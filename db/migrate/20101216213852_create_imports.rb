class CreateImports < ActiveRecord::Migration

  def self.up
    create_table :imports, :force => true do |t|
      t.integer :locations_count, :default => 0
      t.string :input_file_name
      t.string :input_content_type
      t.integer :input_file_size
      t.datetime :input_updated_at
      t.enum :import_format
      t.references :user
      t.timestamps
    end
  end

  def self.down
    drop_table :imports
  end

end
