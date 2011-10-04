class Auditor < ActionController::Caching::Sweeper
  observe Changeset

  def before_create(changeset)
    changeset.user ||= current_user
  end

  def current_user
    controller.send :current_user if controller && controller.respond_to?(:current_user, true)
  end

end