class Category < ActiveRecord::Base
  has_many :tags
  has_many :locations, :through => :tags
  validates_presence_of :french, :english
  has_many :mappings
  has_many :classifications, :through => :mappings
  before_create :process_icon
  before_validation :validate_icon

  def json_object
    {:name => self.french, :icon => self.icon, :id => self.id}
  end

  def bilingual_name
    "#{self.french} / #{self.english}"
  end

  def self.dropdown_items
    sql = "SELECT id, french FROM categories ORDER BY french ASC"
    Category.all.map {|rs| [rs.french, rs.id]}
  end

  private

  def validate_icon

  end

  def process_icon
    if icon.starts_with?("http")
      filename = File.basename(icon)
      path =  "#{Rails.root}/public/images/icons/#{filename}"
      unless File.exists?(path)
        img = File.new(path, 'w')
        img.write(open(icon)) {|f| f.read}
        img.close
      end
      icon = "/icons/#{filename}"
    end
  end
end
