class ImportsController < ApplicationController
  resource_controller
  layout "admin"

  new_action.before do
    @all_users = User.order("login")
    object.user_id = current_user.id
  end

  def create
    file = params[:import][:content].read
    import = Import.new(:content => file, :user_id => params[:import][:user_id], :country_id => params[:import][:country_id])
    counter = import.load
    flash[:msg] = "#{counter} locations were successfully imported."
    redirect_to locations_path
  end

end