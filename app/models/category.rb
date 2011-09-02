require "open-uri"
class Category < ActiveRecord::Base
  has_many :tags
  has_many :locations, :through => :tags
  validates_presence_of :french, :english
  has_many :mappings
  has_many :classifications, :through => :mappings
  before_save :process_icon
  before_validation :validate_icon

  scope :visible, lambda {where(:is_hidden => false)}

  scope :hidden, lambda {where(:is_hidden => true)}

  scope :leaf, lambda {where(:is_leaf => true)}

  def json_object
    {:name => self.french, :icon => self.icon, :id => self.id}
  end

  def bilingual_name
    "#{self.french} / #{self.english}"
  end

  def self.dropdown_items
    Category.select("french, id").order(:french).map {|category| [category.french, category.id]}
  end

  def icon_directory
    "#{Rails.root}/public/assets/images/google"
  end

  def relative_icon_directory
    "/google/"
  end

  private

  def validate_icon

  end

  def process_icon
    if icon.starts_with?("http")
      filename = File.basename(icon)
      path = File.join(icon_directory, "#{english}.png")
      unless File.exists?(path)
        img = File.new(path, 'w')
        img.write(open(icon)) {|f| f.read}
        img.close
      end
      self[:icon] = File.join(relative_icon_directory, filename)
    end
  end
end
