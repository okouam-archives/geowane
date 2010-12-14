class ActsAsAuditedMigration < ActiveRecord::Migration
  def self.up
    create_table :audits, :force => true do |t|
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
      t.column :auditable_id, :integer
      t.column :auditable_type, :string
      t.column :user_id, :integer
      t.column :action, :string
    end
    add_index :audits, [:auditable_id, :auditable_type], :name => 'auditable_index'
    add_index :audits, [:user_id], :name => 'user_index'
    add_index :audits, :created_at  
  end

  def self.down
    drop_table :audits
  end
end
