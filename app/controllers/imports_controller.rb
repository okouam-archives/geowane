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

  create.after do
    if object.import_format == :GPX
      object.locations_count = object.insert
      object.save!
      @redirect = imports_path
    else
      @redirect = preview_import_path(object.id)
    end
  end

  def preview
    @updates = object.preview
  end

  def change
    object.locations_count = object.update(params[:changes])
    object.save!
    redirect_to imports_path
  end

  create.wants.html do
    redirect_to @redirect
  end

end