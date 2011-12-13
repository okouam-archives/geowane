class SearchCriteria

  def initialize(attributes)
    if attributes
      attributes.each do |k,v|
        self.instance_variable_set("@#{k}", v)
      end
    end
  end

  def create_query

    query = Location.scoped.where("1 = 1")

    query = query.select('DISTINCT locations.id')

    query = query.in_bbox(@bbox.split(",")) unless @bbox.nil? || @bbox.blank?

    query = query.where(:user_id => @added_by) unless @added_by.nil? || @added_by.blank?

    query = query.where(:status => @status) unless @status.nil? || @status.blank?

    query = query.on_street(@street_name) unless @street_name.nil? || @street_name.blank?

    query = filter_on_category_presence(query, [@category_id]) unless @category_id.nil? || @category_id.blank?

    query = filter_on_change(query, @modified_by) unless @modified_by.nil? || @modified_by.blank?

    query = filter_on_administrative_unit(query, @level_id)

    query = query.where(:city_id => @cities) if @cities

    query = query.where("locations.created_at > ?", @added_after) unless @added_after.nil? || @added_after.blank?

    query = query.where("locations.created_at < ?", @added_before) unless @added_before.nil? || @added_before.blank?

    query = query.where("locations.updated_at > ?", @modified_after) unless @modified_after.nil? || @modified_after.blank?

    query = query.where("locations.updated_at < ?", @modified_before) unless @modified_before.nil? || @modified_before.blank?

    query = query.named(@name) unless @name.nil? || @name.blank?

    query

  end

  private

  def filter_on_administrative_unit(query, level)
    unless level.blank?
      query = level == "none" ? query.not_geolocated : query.in_boundary(level)
    end
    query
  end

  def filter_on_change(query, modified_by)
    modified_by = modified_by.blank? ? nil : modified_by
    unless modified_by.blank?
      user_id = modified_by
      query = query.joins(:audits).where("audits.user_id = ?", user_id)
    end
    query
  end

  def filter_on_category_presence(query, id)
    query = query.joins('LEFT JOIN "tags" ON "locations"."id" = "tags"."location_id" LEFT JOIN "categories" ON "categories"."id" = "tags"."category_id"')
    query = query.where("categories.id IN (?)", id)
    query
  end

end
