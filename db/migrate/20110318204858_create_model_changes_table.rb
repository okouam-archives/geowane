class CreateModelChangesTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:model_changes)
      create_table :model_changes, :force => true do |t|
        t.column :old_value, :string
        t.references :audit, :foreign_key => true, :dependent => :delete
        t.column :new_value, :string
        t.column :datum, :string
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :model_changes if table_exists?(:model_changes)
  end

end