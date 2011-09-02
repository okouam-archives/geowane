class SearchCriteria < ActiveRecord::Base
  belongs_to :search

  def create_query

    query = Location.scoped

    query = sort ? query.order("#{sort} ASC") : query.order("locations.name")

    query = query
    .select(%{DISTINCT locations.id, longitude, latitude, locations.name,
                locations.created_at, users.login as username, status, locations.updated_at,
                cities.name as city_name, locations.feature, boundaries.name "country"})
    .joins(:user)
    .joins("LEFT JOIN boundaries ON locations.level_0 = boundaries.id")
    .joins("LEFT JOIN cities ON cities.id = locations.city_id")

    query = query.classified_as(classification_id) unless classification_id.blank?

    query = query.in_bbox(bbox.split(",")) unless bbox.blank?

    query = query.labelled("IMPORTED FROM", import_id, "SYSTEM") unless import_id.blank?

    query = query.where(:user_id => added_by) unless added_by.blank?

    query = query.where(:status => status) unless status.blank?

    query = filter_on_category_presence(query, category_missing == "1", category_present == "1", category_id)

    query = filter_on_change(query, confirmed_by, audited_by, modified_by)

    query = filter_on_administrative_unit(query, level_id)

    administrative_unit_id = find_most_selective_level

    query = filter_on_administrative_unit(query, administrative_unit_id)

    query = query.where(:city_id => city_id) unless city_id.blank?

    query = query.where("locations.created_at > ?", added_on_after) unless added_on_after.blank?

    query = query.where("locations.created_at < ?", added_on_before) unless added_on_before.blank?

    query = query.named(name) unless name.blank?

    query

  end

  private

  def find_most_selective_level
    4.downto 0 do |i|
      level_id = send "location_level_#{i}"
      return level_id unless level_id.nil?
    end
    #noinspection RubyUnnecessaryReturn
    return nil
  end

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
      query = query.joins(:audits).where("audits.user_id = ?", user_id)
      if audited_by || confirmed_by
        value = audited_by ? 'audited' : 'field_checked'
        query = query.joins("JOIN model_changes ON audits.id = model_changes.audit_id").where("model_changes.new_value = ?", value)
      end
    end
    query
  end

  def filter_on_category_presence(query, missing, not_missing, id)
    if missing || not_missing || id.present?
      query = query.joins('LEFT JOIN "tags" ON "locations"."id" = "tags"."location_id" LEFT JOIN "categories" ON "categories"."id" = "tags"."category_id"')
      query = query.where("categories.id = ?", id) if id.present?
      query = query.having("count(distinct tags.category_id) > 0") if not_missing
      query = query.having("count(distinct tags.category_id) < 1") if missing
    end
    query
  end

end
