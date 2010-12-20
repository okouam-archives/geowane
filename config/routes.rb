GeoCms::Application.routes.draw do

  match'/locations' => 'locations#collection_delete', :via => :delete 
  match'/locations/edit' => 'locations#collection_edit', :via => [:get, :post] 
  match'/locations' => 'locations#collection_update', :via => :put 

  resources :locations do
    resources :comments, :tags
    member do
      get :next, :previous, :surrounding_landmarks
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
    post :prepare, :on => :collection
  end

  match '/' => 'user_sessions#new'
  match '/dashboard' => 'admin#dashboard', :as => :dashboard

end
