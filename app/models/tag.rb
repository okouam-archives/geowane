class Tag < ActiveRecord::Base
  belongs_to :category, :counter_cache => true  
  belongs_to :location, :counter_cache => true  
end
