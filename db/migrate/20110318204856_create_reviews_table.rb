class CreateReviewsTable < ActiveRecord::Migration

  def self.up
    unless table_exists?(:reviews)
      create_table :reviews, :force => true do |t|
        t.timestamps
        t.references :location, :foreing_key => true
        t.references :user, :foreign_key => true
        t.text :body
      end
    end
    add_index :reviews, [:user_id], :name => 'idx_reviews_user_id'
    add_index :reviews, [:location_id], :name => 'idx_reviews_location_id'
  end

  def self.down
    drop_table :reviews if table_exists?(:reviews)
  end

end
