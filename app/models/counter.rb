class Counter
  attr_reader :total_locations, :field_checked_locations, :audited_locations, :new_locations, :corrected_locations, :invalid_locations, :rejected_locations, :user, :categorized_locations

  def initialize(user)
      connection = ActiveRecord::Base.connection
      @user = user
      @total_locations = connection.select_value("SELECT count(*) FROM locations where user_id = #{user.id}")
      @new_locations = connection.select_value("SELECT count(*) FROM locations where user_id = #{user.id} AND status = 'new'")
      @field_checked_locations = connection.select_value("SELECT count(*) FROM locations where user_id = #{user.id} AND status = 'field_checked'")
      @corrected_locations = connection.select_value("SELECT count(*) FROM locations where user_id = #{user.id} AND status = 'corrected'")
      @invalid_locations = connection.select_value("SELECT count(*) FROM locations where user_id = #{user.id} AND status = 'invalid'")
      @rejected_locations = connection.select_value("SELECT count(*) FROM locations where user_id = #{user.id} AND status = 'rejected'")
      @audited_locations = connection.select_value("SELECT count(*) FROM locations where user_id = #{user.id} AND status = 'audited'")
      @categorized_locations = connection.select_value("SELECT count(*) FROM locations where user_id = #{user.id} AND locations.id IN (SELECT location_id FROM tags JOIN categories ON categories.id = tags.category_id)")
  end

end
