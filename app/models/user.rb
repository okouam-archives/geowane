require 'aegis'
require 'will_paginate'

class User < ActiveRecord::Base
  acts_as_authentic
  has_role
  has_many :locations
  has_many :reviews
  validates_presence_of :role_name

  scope :active, :conditions => {:is_active => true}

  def self.dropdown_items
    sql = "SELECT login, id FROM users ORDER BY login ASC"
    User.connection.select_all(sql).map {|rs| [rs["login"], rs["id"]]}
  end

end
