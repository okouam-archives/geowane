class ExportsController < ApplicationController
  resource_controller
  alias_method :resource_build_object, :build_object
  alias_method :resource_load_object, :load_object

  new_action.before do
    object.class.send :attr_accessor, :output_filename
    flash.keep
  end

  create.before do
    object.class.send :attr_accessor, :output_filename
    flash.keep
  end

  create.after do
    object.user = current_user
    object.locations_count = flash[:locations].size
    object.execute(@output_filename, flash[:locations])
    object.save!
    flash.clear
  end
  
  create.wants.html do
    redirect_to exports_url
  end

  def prepare
    flash[:locations] = params[:export][:locations]
    redirect_to :action => :new
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
    if export_params = params["export"]
      @output_filename = export_params.delete(:output_filename)
    end
  end

end