class User < ActiveRecord::Base
  acts_as_authentic
  has_role
  has_many :locations
  has_many :reviews
  validates_presence_of :role_name

  scope :active, :conditions => {:is_active => true}

  def self.dropdown_items
    User.select("login, id").order("login ASC").map {|user| [user.login, user.id]}
  end

end
