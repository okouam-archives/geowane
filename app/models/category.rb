class Category < ActiveRecord::Base
  has_many :tags
  has_many :locations, :through => :tags
  validates_presence_of :french, :english
  has_many :tags, :counter_cache => true

  def json_object
    {:name => self.french, :icon => self.icon, :id => self.id}
  end

  def bilingual_name
    "#{self.french} / #{self.english}"
  end

end
