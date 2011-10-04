class CreateChangesetsTable < ActiveRecord::Migration
  def change
      create_table :changesets, :force => true do |t|
        t.column :created_at, :datetime
        t.column :updated_at, :datetime
        t.column :auditable_id, :integer
        t.column :auditable_type, :string
        t.references :user, :foreign_key => true
        t.column :action, :string
      end
      add_index :changesets, [:auditable_id, :auditable_type], :name => 'auditable_index'
      add_index :changesets, [:user_id], :name => 'user_index'
      add_index :changesets, :created_at
  end
end
