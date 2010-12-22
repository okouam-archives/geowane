class ExportsController < ApplicationController
  resource_controller

  create.after do
    object.user = current_user
    object.locations_count = session[:locations].size
    object.execute(session[:locations])
    object.save!
  end
  
  create.wants.html do
    redirect_to exports_url
  end

  def prepare    
    session[:locations] = params[:locations]
    redirect_to :action => :new
  end

end
