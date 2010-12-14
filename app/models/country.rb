class Country < ActiveRecord::Base
  validates_presence_of :name
  has_many :locations  
end