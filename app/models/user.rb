require 'aegis'
require 'will_paginate'

class User < ActiveRecord::Base
  acts_as_authentic
  has_role
  has_many :locations
  validates_presence_of :role_name

  scope :active, :conditions => {:is_active => true}

end
