class Region < ActiveRecord::Base
  validates_presence_of :name, :feature

end