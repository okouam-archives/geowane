GeoCms::Application.routes.draw do

  resources :locations do
    collection do
      post :mass_delete
      post :mass_audit
      post :group_edit
    end
    member do
      get :next
      post :group_item_edit
      get :previous
      get :surrounding_landmarks
    end
  end

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

  resource :search, :controller => "search"
  resource :account, :map, :user_sessions
  resources :users, :communes, :cities, :regions, :imports, :countries, :counters, :exports, :conversions

  resources :exports do
    collection do
      post :prepare
    end
  end

  match '/' => 'user_sessions#new'
  match '/dashboard' => 'admin#dashboard', :as => :dashboard

end
