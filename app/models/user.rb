class User < ActiveRecord::Base
  acts_as_authentic
  has_role :default => "collector"
  validates_role
  has_many :locations

  scope :active, :conditions => {:is_active => true}

  def self.dropdown_items
    connection = ActiveRecord::Base.connection
    connection.select_rows("select login, id from users order by login ASC")
  end

end
