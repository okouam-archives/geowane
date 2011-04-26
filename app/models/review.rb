class Review < ActiveRecord::Base
  validates_presence_of :body
  belongs_to :location
  belongs_to :user
end