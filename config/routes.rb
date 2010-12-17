GeoCms::Application.routes.draw do

  resources :locations do
    collection do
      get :search
      get :find
      get :import
      get :change_criteria
      post :mass_delete
      post :mass_audit
      post :mass_update
      post :do_mass_update
      get :export
      post :change_search
    end
    member do
      get :next
      get :previous
      get :surrounding_landmarks
      post :change_status
    end
  end

  resource :user_sessions

  resources :categories do
    collection do
      get :list                            
    end
    member do
      get :change_icon
      get :save_icon
      get :locations
    end
  end               

  resource :account, :map
  resources :users, :communes, :cities, :regions, :imports, :countries, :counters, :exports, :conversions

  resources :exports do
    collection do
      post :selection
    end
  end

  resources :shapefiles do
    member do
      get :download
    end
  end

  match '/' => 'user_sessions#new'
  match '/dashboard' => 'admin#dashboard', :as => :dashboard

end
