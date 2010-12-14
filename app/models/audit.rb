class Audit < ActiveRecord::Base
  belongs_to :auditable, :polymorphic => true
  belongs_to :user
  has_many :model_changes

  before_create :set_audit_user

  def self.as_user(user, &block)
    Thread.current[:acts_as_audited_user] = user
    rtn_val = yield
    Thread.current[:acts_as_audited_user] = nil
    rtn_val
  end

  private

  def set_audit_user
    self.user = Thread.current[:acts_as_audited_user] if Thread.current[:acts_as_audited_user]
    nil # prevent stopping callback chains
  end

end

