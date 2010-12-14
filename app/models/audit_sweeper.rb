class AuditSweeper < ActionController::Caching::Sweeper
  observe Audit

  def before_create(audit)
    audit.user ||= current_user
  end

  def current_user
    controller.send :current_user if controller && controller.respond_to?(:current_user, true)
  end

end