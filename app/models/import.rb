class Import
  include ActiveModel::Validations
  include ActiveModel::Conversion
  extend ActiveModel::Naming

  attr_accessor :content, :user_id, :country_id, :region_id

  def initialize(attributes = {})
    if attributes
      attributes.each_pair do |name, value|
        send("#{name}=", value)
      end
    end
  end

  def persisted?
    false
  end

  def load
    doc = Nokogiri::XML(self.content)
    counter = 0
    user = User.find(self.user_id)
    doc.css("wpt").each do |node|
      longitude = node.attr("lon")
      latitude = node.attr("lat")
      name = node.css("name")[0].inner_text
      next if name.blank?
      location = Location.new(:longitude => longitude, :name => name, :latitude => latitude)
      location.feature = Point.from_x_y(longitude, latitude, 4326)
      location.user = user
      location.save!
      counter = counter + 1
    end
    counter
  end

end