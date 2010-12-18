class ImportsController < ApplicationController
  resource_controller
  layout "admin"

  new_action.before do
    @all_users = User.order("login")
    object.user_id = current_user.id
  end

  create.before do
    @all_users = User.order("login")
  end

  create.before do
    @all_users = User.order("login")
  end

  create.after do
    if object.input_format == :GPX
      object.execute
      object.save!
    end
  end

  create.wants.html do
    redirect_to imports_path
  end

end