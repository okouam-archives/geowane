class SearchCriteria
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :modified_by, :name, :added_by, :category_missing, :category_present, :category_id, :commune_id
  attr_accessor :city_id, :region_id, :country_id, :confirmed_by, :audited_by, :added_on_before, :added_on_after
  attr_accessor :status, :city_level_0, :city_id, :location_level_0, :location_level_1, :location_level_2, :location_level_3
  attr_accessor :field_checked_by, :invalidated_by, :corrected_by
  attr_accessor :street_name, :radius, :location_name, :bbox

  def initialize(attributes = nil)
    
  end

  def persisted?
    false
  end

  def self.create_sql(params = nil, sort = nil, options = nil)

    params = nil unless params.is_a?(Hash)

    query = Location.scoped

    query = sort ? query.order("#{sort} ASC") : query.order("locations.name")

    query = query
    .select(%{locations.id, longitude, latitude, locations.name,
                locations.created_at, users.login as username, status, locations.updated_at,
                cities.name as city_name, locations.feature, boundaries.name "country"})
    .joins(:user)
    .joins("LEFT JOIN boundaries ON locations.level_0 = boundaries.id")
    .joins("LEFT JOIN cities ON cities.id = locations.city_id")

    debugger

    return query if params.nil?

    query = query.group("locations.id, longitude, latitude, locations.name, locations.created_at, users.login, status, locations.updated_at, cities.name, locations.feature, boundaries.name")

    query = query.classified_as(params[:classification_id]) unless params[:classification_id].blank?

    query = query.in_bbox(params[:bbox].split(",")) unless params[:bbox].blank?

    query = query.labelled("IMPORTED FROM", params[:import_id], "SYSTEM") unless params[:import_id].blank?

    query = query.where(:user_id => params[:added_by]) unless params[:added_by].blank?

    query = query.where(:status => params[:status]) unless params[:status].blank?

    query = filter_on_category_presence(query, params[:category_missing] == "1", params[:category_present] == "1", params[:category_id])

    query = filter_on_change(query, params[:confirmed_by], params[:audited_by], params[:modified_by])

    query = filter_on_administrative_unit(query, params[:level_id])

    administrative_unit_id = find_most_selective_level(params)

    query = filter_on_administrative_unit(query, administrative_unit_id)

    query = query.where(:city_id => params[:city_id]) unless params[:city_id].blank?

    query = query.where("locations.created_at > ?", params[:added_on_after]) unless params[:added_on_after].blank?

    query = query.where("locations.created_at < ?", params[:added_on_before]) unless params[:added_on_before].blank?

    query = query.named(params[:name]) unless params[:name].blank?

    query

  end

  private

  def self.find_most_selective_level(criteria)
    4.downto 0 do |i|
      identifier = "location_level_#{i}".to_sym
      level_id = criteria[identifier]
      return level_id unless level_id.nil?
    end
    return nil
  end

  def self.filter_on_administrative_unit(query, level)
    unless level.blank?
      query = level == "none" ? query.not_geolocated : query.in_boundary(level)
    end
    query
  end

  def self.filter_on_change(query, confirmed_by, audited_by, modified_by)
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

  def self.filter_on_category_presence(query, missing, not_missing, id)
    if missing || not_missing || id.present?
      query = query.joins('LEFT JOIN "tags" ON "locations"."id" = "tags"."location_id" LEFT JOIN "categories" ON "categories"."id" = "tags"."category_id"')
      query = query.where("categories.id = ?", id) if id.present?
      query = query.having("count(distinct tags.category_id) > 0") if not_missing
      query = query.having("count(distinct tags.category_id) < 1") if missing
    end
    query
  end

end
