class ImportsController < ApplicationController
  resource_controller
  alias_method :resource_build_object, :build_object
  alias_method :resource_load_object, :load_object
  layout "admin"

  new_action.before do
    @all_users = User.order("login")
    object.user_id = current_user.id
    object.class.send :attr_accessor, :destination
  end

  create.before do
    @all_users = User.order("login")
    object.class.send :attr_accessor, :destination
  end

  create.before do
    @all_users = User.order("login")
  end

  create.after do
    if @destination == "Storage + Database"
      object.execute
      object.save!
    end
  end

  create.wants.html do
    redirect_to imports_path
  end

  def load_object
    update_virtual_attributes
    resource_load_object
  end

  def build_object
    update_virtual_attributes
    resource_build_object
  end

  def update_virtual_attributes
    if import_params = params["import"]
      @destination = import_params.delete(:destination)
    end
  end

end