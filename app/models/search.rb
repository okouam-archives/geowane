class Search

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

  def self.create(params, user)

    query = Location.select("locations.id, locations.name, category_id, categories.french as category_name, locations.created_at, locations.user_id, users.login as username, status, locations.updated_at, cities.name as city_name").
        order("locations.name ASC").
        joins("LEFT JOIN categories ON locations.category_id = categories.id ").
        joins("LEFT JOIN users ON users.id = locations.user_id").
        joins("LEFT JOIN cities ON ST_Within(locations.feature, cities.feature)")

    query = query.where("locations.user_id = ?", user.id) if user && user.has_role?("collector")

    return query if params.nil?

    query = query.where("status = ?", params[:status]) unless params[:status].blank?

    query = query.where("user_id = ?", params[:added_by]) unless params[:added_by].blank?

    if params[:missing_category] == "1"
      query = query.where("category_id IS NULL")
    end

    unless params[:country_id_eq].blank?
      query = query.joins("join countries on ST_Within(locations.feature, countries.feature)").where("countries.id = ?", params[:country_id_eq])
    end

    query = query.where("category_id = ? ", params[:category_id_eq]) unless params[:category_id_eq].blank?

    unless params[:commune_id_eq].blank?
      query = query.joins("join communes on ST_Within(locations.feature, communes.feature)").where("communes.id = ?", params[:commune_id_eq])
    end

    unless params[:city_id_eq].blank?
      query = query.where("cities.id = ?", params[:city_id_eq])
    end

    unless params[:region_id_eq].blank?
      query = query.joins("join regions on ST_Within(locations.feature, regions.feature)").where("regions.id = ?", params[:region_id_eq])
    end

    query = query.where("created_at > ?", params[:added_on_after]) unless params[:added_on_after].blank?

    query = query.where("created_at < ?", params[:added_on_before]) unless params[:added_on_before].blank?

    unless params[:audited_by].blank?
      query = query.
          joins("JOIN audits ON audits.auditable_id = locations.id AND audits.user_id = #{params[:audited_by]}").
          joins("JOIN model_changes ON audits.id = model_changes.audit_id AND model_changes.new_value = 'AUDITED'")
    end

    query = query.where("locations.name ilike ? ", "%#{params[:searchable_name_like]}%") unless params[:searchable_name_like].blank?

    unless params[:confirmed_by].blank?
      query = query.
          joins("JOIN audits ON audits.auditable_id = locations.id AND audits.user_id = #{params[:confirmed_by]}").
          joins("JOIN model_changes ON audits.id = model_changes.audit_id AND model_changes.new_value = 'FIELD CHECKED'")
    end

    query

  end

  private

  def self.current_range_and_index(sql, id)
    locations = Location.find_by_sql(sql).map{|l|l.id}
    index = locations.index id.to_i
    return locations, index
  end

end
