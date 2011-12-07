class ImportsController < ApplicationController
  resource_controller
  layout "admin"

  new_action.before do
    @all_users = User.order("login")
    object.user_id = current_user.id
  end

  def index
    setup_paging(:imports_index_page, params)
    @imports = Import.paginate(:page => params[:page] || 1, :per_page => params[:per_page] || 10)
  end

  create.before do
    @all_users = User.dropdown_items
  end

  def preview
    @selections = object.selections
  end

  def execute
    object.execute(params[:selected])
    redirect_to imports_path
  end

  create.wants.html do
    redirect_to preview_import_path(object.id)
  end

  private

  def setup_paging(key, options, page_size = 10)
    session[key] = options[:page] || session[key]
    @per_page = options[:per_page] || page_size
  end

end