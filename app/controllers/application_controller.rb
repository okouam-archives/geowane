class ApplicationController < ActionController::Base
  before_filter :require_user
  before_filter :set_locale
  cache_sweeper :audit_sweeper
  helper :all
  around_filter :convert_permission_error
  helper_method :current_user
  protect_from_forgery
  layout "admin"

  private
 
  def set_locale
    if current_user
      I18n.locale = current_user.locale
    else
      I18n.default_locale
    end
  end
  
  def convert_permission_error
    yield
  rescue Aegis::AccessDenied
    render :text => "Access denied.", :status => :forbidden
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find

  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def require_user
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_sessions_url
      false
    end
  end

  def require_no_user
    if current_user
      flash[:notice] = "You must be logged out to access this page"
      redirect_to dashboard_url
      false
    end
  end

end

