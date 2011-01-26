class AdminController < ApplicationController

  def dashboard
    @location_count = Location.count
    @commune_count = Commune.count
    @region_count = Region.count
    @city_count = City.count
    @new_locations = Location.where("status = 'new'").count
    @audited_locations = Location.where("status = 'audited'").count
    @invalid_locations = Location.where("status = 'invalid'").count
    @field_checked_locations = Location.where("status = 'field_checked'").count
    @corrected_locations = Location.where("status = 'corrected'").count
  end

end
