class CreateModelChangesTable < ActiveRecord::Migration
  def change
    create_table :model_changes, :force => true do |t|
      t.column :old_value, :string
      t.references :audit, :foreign_key => true, :dependent => :delete
      t.column :new_value, :string
      t.column :datum, :string
      t.timestamps
    end
  end
end