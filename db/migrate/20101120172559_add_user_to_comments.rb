class AddUserToComments < ActiveRecord::Migration
  def up
    add_column :comments, :user_id, :integer
  end

  def down
  end
end
