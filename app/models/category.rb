class Category < ActiveRecord::Base
  has_many :locations, :through => :tags
  has_many :roads
  has_many :tags
  belongs_to :classification
  validates_presence_of :french, :english
  mount_uploader :icon, IconUploader

  scope :visible, lambda {where(:is_hidden => false)}

  scope :hidden, lambda {where(:is_hidden => true)}

  def json_object
    {:name => self.french, :icon => self.icon, :id => self.id}
  end

  def bilingual_name
    "#{self.french} / #{self.english}"
  end

  def self.dropdown_items
    Category.select("french, id").order(:french).map {|category| [category.french, category.id]}
  end

end
