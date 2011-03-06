class LocationCollection

  attr_reader :items

  def initialize(locations)
    if locations.all? {|location| location.is_a? Location}
      @items = locations
    else
      @items = Location.find(locations)
    end
  end

  def remove_tag(category)
    id = (category.is_a? Category) ? category.id : category
    @items.map do |location|
      tag = location.tags.where("category_id = ?", id)
      unless tag.empty?
        Tag.delete(tag.first)
        {location_id: location.id, tag_id: tag.first.id}
      end
    end.compact
  end

  def add_tag(category)
    new_category = (category.is_a? Category) ? category : Category.find(category)
    @items.map do |location|
      unless (location.tags.where("category_id = ?", new_category.id).count > 0)
        tag = location.tags.create(category: new_category)
        {location_id: location.id, tag_id: tag.id, name: new_category.french}
      end
    end.compact
  end

end