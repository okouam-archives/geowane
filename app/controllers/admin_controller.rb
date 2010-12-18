class AdminController < ApplicationController

  def dashboard
    @location_count = Location.count(:all)
    @commune_count = Commune.count(:all)
    @region_count = Region.count(:all)
    @city_count = City.count(:all)
    @new_locations = Location.where("status = 'new'").count
    @audited_locations = Location.where("status = 'audited'").count
    @invalid_locations = Location.where("status = 'nvalid'").count
    @field_checked_locations = Location.where("status = 'field_checked'").count
    @corrected_locations = Location.where("status = 'corrected'").count
  end

end