class Permissions < Aegis::Permissions
  role :collector
  role :auditor
  role :administrator, :default_permission => :allow

  resources :locations do

    allow :everyone

    action :update do
      allow :auditor
      allow :collector do
        (object.is_invalid? || object.is_new?) && object.user == user
      end
    end

    action :destroy do
      allow :auditor
      allow :collector do
        (object.is_new? || object.is_invalid?) && object.user == user
      end
    end

    action :change_status_of do

      allow :collector do |new_status|
        if new_status
          (object.is_invalid? && object.user == user && new_status == :corrected) || new_status == object.status
        else
          object.status == :invalid
        end
      end

      allow :auditor do |new_status|
        if new_status
          ((object.is_new? && [:audited, :invalid].include?(new_status)) ||
            (object.is_invalid? && [:audited].include?(new_status)) ||
            (object.is_corrected? && [:audited, :invalid].include?(new_status)) ||
            (object.is_audited? && [:field_checked, :invalid].include?(new_status))) || new_status == object.status
        else
          true
        end
      end

    end

  end

  resources :users do
    action :index do
      allow :auditor
    end
  end

  resources :exports do
    allow :administrator
  end

  resources :categories do
    action :index do
      allow :everyone
    end
    action :destroy do
      allow :administrator
    end
    action :create do
      allow :administrator
    end
    action :edit do
      allow :administrator
    end
  end

  action :edit_area do
  end

end
