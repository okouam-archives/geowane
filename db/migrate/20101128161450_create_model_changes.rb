class CreateModelChanges < ActiveRecord::Migration

  def self.up
    create_table :model_changes, :force => true do |t|
      t.column :old_value, :string
      t.references :audit
      t.column :new_value, :string
      t.column :datum, :string
     end
  end

  def self.down
    drop_table :model_changes
  end

end