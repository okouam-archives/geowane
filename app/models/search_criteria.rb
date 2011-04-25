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

  def self.create_sql(params = nil, sort = nil)

    params = nil unless params.is_a?(Hash)

    query = {sort: sort ? " ORDER BY #{sort} ASC" : " ORDER BY locations.name ASC"}

    query[:from] = %{
      SELECT
        locations.id, longitude, latitude, locations.name, locations.created_at, users.login as username,
        status, locations.updated_at, cities.name as city_name
      FROM locations
      JOIN users ON users.id = locations.user_id
      LEFT JOIN cities ON cities.id = locations.city_id
    }

    return query[:from] + query[:sort] if params.nil?

    query[:where] = " WHERE 1 = 1 "

    query[:group_by] = %{
      GROUP BY locations.id, longitude, latitude, locations.name, locations.created_at, users.login, status, locations.updated_at, cities.name
    }

    query = filter_on_status(query, params[:status])

    query = filter_on_user(query, params[:added_by])

    query = filter_on_category_presence(query, params[:category_missing] == "1", params[:category_present] == "1", params[:category_id])

    query = filter_on_label(query, params[:import_id])

    query = filter_on_change(query, params[:confirmed_by], params[:audited_by], params[:modified_by])

    administrative_unit_id = find_most_selective_level(params)

    query = filter_on_administrative_unit(query, administrative_unit_id)

    query = filter_on_city(query, params[:city_id])

    query = filter_on_bbox(query, params[:bbox])

    query = filter_on_creation_after_date(query, params[:added_on_after])

    query = filter_on_creation_before_date(query, params[:added_on_before])

    query = filter_on_name(query, params[:name])

    query[:from] + query[:where] + query[:group_by] + (query[:having] || "") + query[:sort]

  end

  private

  def self.filter_on_bbox(query, bbox)
    coords = bbox.split(",")
     query.tap do |o|
      unless bbox.blank?
        o[:where] = "#{o[:where]} AND ST_Intersects(SetSRID('BOX(#{coords[0]} #{coords[1]},#{coords[2]} #{coords[3]})'::box2d::geometry, 4326), locations.feature)"
      end
    end
  end

  def self.find_most_selective_level(criteria)
    level_id = criteria[:location_level_4]
    level_id = criteria[:location_level_3] if level_id.nil?
    level_id = criteria[:location_level_2] if level_id.nil?
    level_id = criteria[:location_level_1] if level_id.nil?
    level_id = criteria[:location_level_0] if level_id.nil?
    level_id
  end

  def self.filter_on_name(query, field)
    query.tap do |o|
      unless field.blank?
        o[:where] = "#{o[:where]} AND locations.name ilike '%#{field}%'"
      end
    end
  end

  def self.filter_on_city(query, field)
    query.tap do |o|
      unless field.blank?
        o[:where] = "#{o[:where]} AND cities.id = #{field}"
      end
    end
  end

  def self.filter_on_creation_before_date(query, date)
    query.tap do |o|
      unless date.blank?
        o[:where] = "#{o[:where]} AND locations.created_at < '#{date}'"
      end
    end
  end

  def self.filter_on_creation_after_date(query, date)
    query.tap do |o|
      unless date.blank?
        o[:where] = "#{o[:where]} AND locations.created_at > '#{date}'"
      end
    end
  end

  def self.filter_on_administrative_unit(query, level)
    query.tap do |o|
      unless level.blank?
        if level == "none"
          o[:where] = "#{o[:where]} AND level_0 IS NULL AND level_1 IS NULL AND level_2 IS NULL AND level_3 IS NULL"
        else
          o[:where] = "#{o[:where]} AND (level_0 = #{level} OR level_1 = #{level} OR level_2 = #{level} OR level_3 = #{level})"
        end
      end
    end
  end

  def self.filter_on_status(query, field)
    query.tap do |o|
      o[:where] = "#{o[:where]} AND status = '#{field}'" unless field.blank?
    end
  end

  def self.filter_on_change(query, confirmed_by, audited_by, modified_by)
    confirmed_by = confirmed_by.blank? ? nil : confirmed_by
    modified_by = modified_by.blank? ? nil : modified_by
    audited_by = audited_by.blank? ? nil : audited_by
    query.tap do |o|
      unless confirmed_by.blank? && audited_by.blank? && modified_by.blank?
        user_id = confirmed_by || audited_by || modified_by
        query[:from] = "#{o[:from]} JOIN audits ON audits.auditable_id = locations.id AND audits.user_id = #{user_id}"
        if audited_by || confirmed_by
          value = audited_by ? 'audited' : 'field_checked'
          query[:from] = "#{o[:from]} JOIN model_changes ON audits.id = model_changes.audit_id AND model_changes.new_value = '#{value}'"
        end
      end
    end
  end

  def self.filter_on_category_presence(query, missing, not_missing, id)
    query.tap do |o|
      if missing || not_missing || id.present?
        o[:from] = "#{o[:from]} LEFT JOIN tags ON tags.location_id = locations.id"
        o[:from] = "#{o[:from]} JOIN categories ON tags.category_id = categories.id AND categories.id = #{id}" if id.present?
        o[:having] = "HAVING 1 = 1 AND count(distinct tags.category_id) > 0" if not_missing
        o[:having] = "HAVING 1 = 1 AND count(distinct tags.category_id) < 1" if missing
      end
    end   
  end

  def self.filter_on_label(query, field)
    query.tap do |o|
      unless field.blank?
        o[:from] = "#{o[:from]} JOIN labels ON labels.location_id = locations.id"
        o[:where] = "#{o[:where]} AND labels.key ilike 'IMPORTED FROM' AND labels.classification ilike 'SYSTEM' AND labels.value = '#{field}'"
      end
    end
  end

  def self.filter_on_user(query, field)
    query.tap do |o|
      o[:where] = "#{o[:where]} AND user_id = #{field}" unless field.blank?
    end
  end

end
