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

    query = query.in_bbox(@bbox.split(",")) if @bbox

    query = query.where(:user_id => @added_by) if @added_by

    query = query.where(:status => @statuses) if @statuses

    query = query.on_street(street_name) if @street_name

    query = filter_on_category_presence(query, @categories) if @categories

    query = filter_on_change(query, @confirmed_by, @audited_by, @modified_by)

    query = filter_on_administrative_unit(query, @level_id)

    query = query.where(:city_id => @cities) if @cities

    query = query.where("locations.created_at > ?", @added_on_after) if @added_on_after

    query = query.where("locations.created_at < ?", @added_on_before) if @added_on_before

    query = query.named(@name) if @name

    query

  end

  private

  def filter_on_administrative_unit(query, level)
    unless level.blank?
      query = level == "none" ? query.not_geolocated : query.in_boundary(level)
    end
    query
  end

  def filter_on_change(query, confirmed_by, audited_by, modified_by)
    confirmed_by = confirmed_by.blank? ? nil : confirmed_by
    modified_by = modified_by.blank? ? nil : modified_by
    audited_by = audited_by.blank? ? nil : audited_by
    unless confirmed_by.blank? && audited_by.blank? && modified_by.blank?
      user_id = confirmed_by || audited_by || modified_by
      query = query.joins(:changesets).where("changesets.user_id = ?", user_id)
      if audited_by || confirmed_by
        value = audited_by ? 'audited' : 'field_checked'
        query = query.joins("JOIN changes ON changesets.id = changes.changeset_id").where("changes.new_value = ?", value)
      end
    end
    query
  end

  def filter_on_category_presence(query, id)
    query = query.joins('LEFT JOIN "tags" ON "locations"."id" = "tags"."location_id" LEFT JOIN "categories" ON "categories"."id" = "tags"."category_id"')
    query = query.where("categories.id IN (?)", id)
    query
  end

end
