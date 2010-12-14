module Audited

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    def acts_as_audited

      return if self.included_modules.include?(Audited::InstanceMethods)

      class_inheritable_reader :non_audited_columns

      except = [self.primary_key, inheritance_column, 'lock_version', 'created_at', 'updated_at', 'created_on', 'updated_on', 'searchable_name', 'feature']

      write_inheritable_attribute :non_audited_columns, except

      has_many :audits, :as => :auditable

      after_create :audit_create
      before_update :audit_update
      before_destroy :audit_destroy

      include InstanceMethods

    end

  end

  module InstanceMethods

    def audited_attributes
      attributes.except(*non_audited_columns)
    end

    private

    def audited_changes
      changed_attributes.except(*non_audited_columns).inject({}) do |changes,(attr, old_value)|
        changes[attr] = [old_value, self[attr]]
        changes
      end
    end

    def audit_create
      audit = self.audits.create :action => 'create'
      audited_attributes.each do |key, value|
        new_value = value
        if key == "category_id"
           new_value = Category.find(value).bilingual_name unless value.blank?
        end
        audit.model_changes.create(:datum => key, :old_value => '', :new_value => new_value)
      end
    end

    def audit_update
      unless (model_changes = audited_changes).empty?
        audit = self.audits.create :action => 'update'
        model_changes.each do |key, value|
          old_value = value[0]
          new_value = value[1]
          next if (old_value.blank? && new_value.blank?)
          if key == "category_id"
            old_value = Category.find(value[0]).bilingual_name unless value[0].blank?
            new_value = Category.find(value[1]).bilingual_name unless value[1].blank?
          end
          audit.model_changes.create(:datum => key, :old_value => old_value, :new_value => new_value)
        end
      end
    end

    def audit_destroy
      audit = self.audits.create :action => 'destroy'
      audited_attributes.each do |key, value|
        old_value = value
        begin
          old_value = Category.find(value).bilingual_name if key == "category_id"
        rescue
        end
        audit.model_changes.create(:datum => key, :old_value => old_value, :new_value => '')
      end
    end

  end

end