GeoCms::Application.routes.draw do

  resources :locations do
    resources :comments, :tags
    collection do
      post :collection_delete, :collection_edit
    end
    member do
      get :next, :previous, :surrounding_landmarks
      post :group_item_edit
    end
  end

  resources :categories do
    member do
      get :locations, :save_icon, :change_icon
    end
  end               

  resource :search, :controller => "search"
  resource :account, :controller => "account"
  resource :map, :controller => "map"
  resource :user_sessions
  resources :users, :communes, :cities, :regions, :imports, :countries, :counters, :exports, :conversions

  resources :exports do
    collection do
      post :prepare
    end
  end

  match '/' => 'user_sessions#new'
  match '/dashboard' => 'admin#dashboard', :as => :dashboard

end
