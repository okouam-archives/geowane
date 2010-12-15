class Permissions < Aegis::Permissions
  role :collector
  role :auditor
  role :administrator, :default_permission => :allow

  resources :locations do

    allow :everyone

    action :update do
      allow :auditor
      allow :collector do
        (object.status == 'INVALID' || object.status == 'NEW') && object.user == user
      end
    end

    action :destroy do
      allow :auditor
      allow :collector do
        (object.status == 'NEW' || object.status == 'INVALID') && object.user == user
      end
    end

    action :change_status_of do

      allow :collector do |new_status|
        if new_status
          (object.status == 'INVALID' && object.user == user && new_status == "CORRECTED") || new_status == object.status
        else
          object.status == 'INVALID'
        end
      end

      allow :auditor do |new_status|
        if new_status
          ((object.status == 'NEW' && ["AUDITED", "INVALID"].include?(new_status)) ||
            (object.status == 'INVALID' && ["AUDITED"].include?(new_status)) ||
            (object.status == 'CORRECTED' && ["AUDITED", "INVALID"].include?(new_status)) ||
            (object.status == 'AUDITED' && ["FIELD CHECKED", "INVALID"].include?(new_status))) || new_status == object.status
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

  resources :categories do
    action :index do
      allow :everyone
    end
  end

  action :edit_area do
  end

end
