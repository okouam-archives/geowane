class AdminController < ApplicationController

  def dashboard
    @location_count = Location.count
    @level_3_count = AdministrativeUnit.where("level = 3").count
    @level_1_count = AdministrativeUnit.where("level = 1").count
    @level_2_count = AdministrativeUnit.where("level = 2").count
    @level_0_count = AdministrativeUnit.where("level = 0").count
    @new_locations = Location.where("status = 'new'").count
    @audited_locations = Location.where("status = 'audited'").count
    @invalid_locations = Location.where("status = 'invalid'").count
    @field_checked_locations = Location.where("status = 'field_checked'").count
    @corrected_locations = Location.where("status = 'corrected'").count
  end

end
