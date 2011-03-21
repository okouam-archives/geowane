class CreateCommentsTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:comments)
      create_table :comments do |t|
        t.string :title, :limit => 50, :default => ""
        t.text :comment
        t.references :commentable, :polymorphic => true
        t.references :user, :foreign_key => true
        t.timestamps
      end
      add_index :comments, :commentable_type
      add_index :comments, :commentable_id
      add_index :comments, :user_id
    end
  end

  def self.down
    drop_table :comments if table_exists?(:comments)
  end

end