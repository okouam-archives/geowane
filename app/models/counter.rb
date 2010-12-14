class Counter
  attr_reader :total_locations, :field_checked_locations, :audited_locations, :new_locations, :corrected_locations, :invalid_locations, :rejected_locations, :user, :categorized_locations

  def initialize(user)
      @user = user
      @total_locations = Location.where("user_id = ?", user.id).count
      @new_locations = Location.where("user_id = ?", user.id).where("status = 'NEW'").count
      @field_checked_locations = Location.where("user_id = ?", user.id).where("status = 'FIELD CHECKED'").count
      @corrected_locations = Location.where("user_id = ?", user.id).where("status = 'CORRECTED'").count
      @invalid_locations = Location.where("user_id = ?", user.id).where("status = 'INVALID'").count
      @rejected_locations = Location.where("user_id = ?", user.id).where("status = 'REJECTED'").count
      @audited_locations = Location.where("user_id = ?", user.id).where("status = 'AUDITED'").count
      @categorized_locations = Location.where("user_id = ?", user.id).where("category_id IS NOT NULL").count
  end

end