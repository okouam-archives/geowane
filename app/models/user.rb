require 'aegis'
require 'will_paginate'

class User < ActiveRecord::Base
  acts_as_authentic do |c|
   c.validates_length_of_password_field_options = {
    :on => :update, :minimum => 4, :if => :has_no_credentials?
   }
   c.validates_length_of_password_confirmation_field_options = {
    :on => :update, :minimum => 4, :if => :has_no_credentials?
   }
  end
  has_role
  has_many :locations
  validates_presence_of :role_name

  scope :active, :conditions => {:is_active => true}

 def signup!(params)
  self.login = params[:user][:login]
  self.email = params[:user][:email]
  self.mobile_number = params[:user][:mobile_number]
  self.skype_alias = params[:user][:skype_alias]
  self.home_country = params[:user][:home_country]
  # Ces colonnes sont NOT NULL, on évite une erreur SQL
  self.crypted_password = ''
  self.password_salt = ''
  self.is_active = false
  save_without_session_maintenance
 end

end
