class Counter
  attr_reader :total_locations, :field_checked_locations, :audited_locations, :new_locations, :corrected_locations, :invalid_locations, :rejected_locations, :user, :categorized_locations

  def initialize(user)
      @user = user
      @total_locations = Location.where("user_id = ?", user.id).count
      @new_locations = Location.where("user_id = ?", user.id).where("status = 'new'").count
      @field_checked_locations = Location.where("user_id = ?", user.id).where("status = 'field_checked'").count
      @corrected_locations = Location.where("user_id = ?", user.id).where("status = 'corrected'").count
      @invalid_locations = Location.where("user_id = ?", user.id).where("status = 'invalid'").count
      @rejected_locations = Location.where("user_id = ?", user.id).where("status = 'rejected'").count
      @audited_locations = Location.where("user_id = ?", user.id).where("status = 'audited'").count
      @categorized_locations = Location.where("user_id = ?", user.id).where("locations.id IN (SELECT location_id FROM tags JOIN categories ON categories.id = tags.category_id)").count
  end

end
