class UsersController < ApplicationController
  resource_controller
  before_filter :check_edit_permissions, :only => [:update, :edit]
  before_filter :check_create_permissions, :only => [:new_action, :create]
  layout "admin"

  def index
    current_user.may_list_users!
    @sort_params = params.merge({controller: "users", action: "index"}).except(:page, :per_page)
    per_page = params[:per_page] || "10"
    order = params[:sort] || "login"
    query = User.order(order)
    query = query.where("users.login ILIKE ?", "%#{params[:s][:name]}%") if params[:s]
    @users = query.paginate(:page => params[:page], :per_page => per_page)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      redirect_to users_path
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
