class CreateUsersTable < ActiveRecord::Migration
  def change
      create_table :users do |t|
        t.string :login, :null => false
        t.string :email, :null => false
        t.string :crypted_password, :null => false
        t.string :password_salt, :null => false
        t.string :persistence_token, :null => false
        t.datetime :last_login_at
        t.string :last_login_ip
        t.string :role_name
        t.boolean :is_active, :default => true, :null => false
        t.string :mobile_number
        t.string :skype_alis
        t.string :home_country
        t.string :locale, :default => "en"
        t.timestamps
      end
  end
end