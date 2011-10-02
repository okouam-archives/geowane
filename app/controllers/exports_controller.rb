class ExportsController < ApplicationController
  include Aegis::Controller
  resource_controller

  PAGER = :exports_index_page

  create.after do
    parameters = session[:selection]
    object.user = current_user
    object.locations_count = parameters[:locations].size
    sql = %{
      SELECT DISTINCT
        locations.id,
        cities.name as city,
        boundary_0.name as country,
        boundary_1.name as region,
        locations.name,
        locations.feature,
        partners.name as partner,
        partner_categories.french as french_category,
        partner_categories.english as english_category,
        partner_categories.code as code
      FROM
        locations
        LEFT JOIN cities on cities.id = locations.city_id
        LEFT JOIN boundaries boundary_0 ON boundary_0.level = 0 AND boundary_0.id = locations.level_0
        LEFT JOIN boundaries boundary_1 ON boundary_1.level = 1 AND boundary_1.id = locations.level_1
        JOIN tags ON tags.location_id = locations.id
        JOIN categories ON categories.id = tags.category_id
        JOIN mappings ON mappings.category_id = categories.id
        JOIN partner_categories ON partner_categories.id = mappings.partner_category_id
        JOIN partners ON partners.id = partner_categories.partner_id
      WHERE
        locations.id IN (#{parameters[:locations].join(",")})
        AND partners.id = #{parameters[:partner_id]}
    }
    object.execute Location.find_by_sql(sql)
    object.description = parameters[:description]
    object.output_format = ".SHP"
    object.save!
  end

  def index
    session[PAGER] = params[:page] || session[PAGER]
    @per_page = params[:per_page] || 10
    @exports = Export.order("created_at desc").page(session[PAGER]).per(@per_page)
  end
  
  create.wants.html do
    redirect_to exports_url
  end

  def selection
    @all_countries = Boundary.dropdown_items(0)
    @all_users = User.dropdown_items
    @all_statuses = Location.new.enums(:status).select_options
  end

  def count
    render :text => Export.locate(params[:export])[:locations].count
  end

  def prepare
    if params[:export]
      session[:selection] = Export.locate(params[:export])
    else
      session[:selection] = {
        locations: params[:locations],
        partner_id: Partner.find_by_name("0-One").id,
        description: "Manual selection"
      }
    end
    redirect_to :action => :new
  end

end
