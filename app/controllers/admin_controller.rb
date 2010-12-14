class AdminController < ApplicationController

  def dashboard
    @location_count = Location.count(:all)
    @commune_count = Commune.count(:all)
    @region_count = Region.count(:all)
    @city_count = City.count(:all)
    @new_locations = Location.where("status = 'NEW'").count
    @audited_locations = Location.where("status = 'AUDITED'").count
    @invalid_locations = Location.where("status = 'INVALID'").count
    @field_checked_locations = Location.where("status = 'FIELD CHECKED'").count
    @corrected_locations = Location.where("status = 'CORRECTED'").count
  end

end