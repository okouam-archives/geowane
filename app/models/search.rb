class Search
  extend ActiveModel::Naming
  include ActiveModel::Conversion

  attr_accessor :modified_by, :name, :added_by, :category_missing, :category_present, :category_id, :commune_id
  attr_accessor :city_id, :region_id, :country_id, :confirmed_by, :audited_by, :added_on_before, :added_on_after
  attr_accessor :status

  def initialize(attributes)
    
  end

  def persisted?
    false
  end

  def self.find_next(sql, id)
    locations, index = current_range_and_index(sql, id)
    new_index = index + 1
    new_index = 0 if new_index >= locations.length
    locations[new_index]
  end

  def self.find_previous(sql, id)
    locations, index = current_range_and_index(sql, id)
    new_index = index - 1
    new_index = locations.length - 1 if new_index < 0
    locations[new_index]
  end

  def self.create(params = nil, sort = nil)

    query = Location.select("locations.id, locations.tags_count, longitude, latitude, locations.name, locations.created_at, locations.user_id, users.login as username, status, locations.updated_at, cities.name as city_name").
        joins("LEFT JOIN users ON users.id = locations.user_id").
        joins("JOIN topologies ON topologies.location_id = locations.id").
        joins("LEFT JOIN cities ON cities.id = topologies.city_id")

    query = set_sorting_order(query, sort)

    return query.to_sql if params.nil?

    query = query.where("status = ?", params[:status]) unless params[:status].blank?

    query = query.where("user_id = ?", params[:added_by]) unless params[:added_by].blank?

    if params[:category_missing] == "1"
      query = query.where("tags_count < 1")
    end

    if params[:category_present] == "1"
      query = query.where("tags_count > 0")
    end

    unless params[:import_id].blank?
      query = query.joins("JOIN labels ON labels.location_id = locations.id")
        .where("labels.key ilike 'IMPORTED FROM' AND labels.classification ilike 'SYSTEM' AND labels.value = ?", params[:import_id])
    end

    unless params[:level_id].blank?
      level = params[:level_id]
      if level == "none"
        query = query.where("level_0 IS NULL AND level_1 IS NULL AND level_2 IS NULL AND level_3 IS NULL")
      else
        query = query.where("level_0 = #{level} OR level_1 = #{level} OR level_2 = #{level} OR level_3 = #{level}")
      end
    end

    unless params[:category_id].blank?
      query = query.
          joins(:tags).
          joins("JOIN categories ON tags.category_id = categories.id AND categories.id = #{params[:category_id]}")
    end

    unless params[:city_id].blank?
      query = query.where("cities.id = ?", params[:city_id])
    end

    query = query.where("locations.created_at > ?", params[:added_on_after]) unless params[:added_on_after].blank?

    query = query.where("locations.created_at < ?", params[:added_on_before]) unless params[:added_on_before].blank?

    unless params[:audited_by].blank?
      query = query.
          joins("JOIN audits ON audits.auditable_id = locations.id AND audits.user_id = #{params[:audited_by]}").
          joins("JOIN model_changes ON audits.id = model_changes.audit_id AND model_changes.new_value = 'audited'")
    end

    query = query.where("locations.name ilike ? ", "%#{params[:name]}%") unless params[:name].blank?

    unless params[:modified_by].blank?
      query = query.joins("JOIN audits ON audits.auditable_id = locations.id AND audits.user_id = #{params[:modified_by]}")
    end

    unless params[:confirmed_by].blank?
      query = query.
          joins("JOIN audits ON audits.auditable_id = locations.id AND audits.user_id = #{params[:confirmed_by]}").
          joins("JOIN model_changes ON audits.id = model_changes.audit_id AND model_changes.new_value = 'field_checked'")
    end

    query.to_sql

  end

  private

  def self.set_sorting_order(query, sort)
    if sort
      query.order(sort + " ASC")
    else
      query.order("locations.name ASC")
    end
  end

  def self.current_range_and_index(sql, id)
    locations = Location.find_by_sql(sql).map{|l|l.id}
    index = locations.index id.to_i
    return locations, index
  end

end
