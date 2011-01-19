class UsersController < ApplicationController
  resource_controller
  before_filter :require_user, :except => [:new, :create]
  before_filter :check_edit_permissions, :only => [:update, :edit]
#  before_filter :check_create_permissions, :only => [:new_action, :create]
  layout "admin"

  def index
    current_user.may_list_users!
    per_page = params[:per_page] || "10"
    @users = User.order("login").paginate(:page => params[:page], :per_page => per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.signup!(:user => params[:user])
      flash[:notice] = "Patienter une demande d'activation est adressé à l'administrateur" 
      redirect_to user_sessions_url
    else
      render :action => "new"
    end
  end

  update.wants.html do
     redirect_to users_path
  end

  private

  def check_edit_permissions
    current_user.may_edit_category!(object)
  end

  def check_create_permissions
    current_user.may_create_category!(object)
  end

end
