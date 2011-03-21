class CreateUsersTable < ActiveRecord::Migration

  def self.up
    unless connection.table_exists?(:users)
      create_table :users do |t|
        t.string :login, :null => false
        t.string :email, :null => false
        t.string :crypted_password, :null => false
        t.string :password_salt, :null => false
        t.string :persistence_token, :null => false
        t.string :single_access_token, :null => false
        t.string :perishable_token, :null => false
        t.integer :login_count, :null => false, :default => 0
        t.integer :failed_login_count, :null => false, :default => 0
        t.datetime :last_request_at
        t.datetime :current_login_at
        t.datetime :last_login_at
        t.string :current_login_ip
        t.string :last_login_ip
        t.string :role_name
        t.boolean :is_active, :default => true, :null => false
        t.string :mobile_number
        t.string :skype_alis
        t.string :home_country
        t.timestamps
      end
    end
  end

  def self.down
    drop_table :users if connection.table_exists?(:users)
  end

end