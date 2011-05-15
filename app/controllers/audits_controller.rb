class AuditsController < ApplicationController
  resource_controller
  layout "admin", :except => [:show]

  def index
    sql = %{
      select audits.id, audits.created_at, auditable_id, login, old_value as name, 'DELETED' as action
      from audits JOIN users on audits.user_id = users.id
      LEFT JOIN model_changes ON audit_id = audits.id
      where auditable_type = 'Location' and action = 'destroy' AND datum = 'name'
      ORDER BY created_at DESC
    }
    page = params[:page] || 1
    @per_page = params[:per_page] || 10
    @audits = Location.paginate_by_sql(sql, :page => page, :per_page => @per_page)
  end

end