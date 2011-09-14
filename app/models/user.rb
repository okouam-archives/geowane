class User < ActiveRecord::Base
  acts_as_authentic
  has_role :default => "collector"
  validates_role
  has_many :locations

  scope :active, :conditions => {:is_active => true}

  def self.dropdown_items
    User.select("login, id").order("login ASC").map {|user| [user.login, user.id]}
  end

end
