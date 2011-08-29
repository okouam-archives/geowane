Gowane::Application.routes.draw do

  match'/locations' => 'locations#collection_delete', :via => :delete
  match'/locations/edit' => 'locations#collection_edit', :via => [:get, :post] 
  match'/locations' => 'locations#collection_update', :via => :put 
  match '/icon/:num.gif' => 'graphics#draw_icon'
  match '/api/:action', :controller => 'api'
  match '/landmarks' => 'landmarks#index', :as => "landmarks", :via => :get

  resources :locations do
    resources :comments, :tags
    member do
      get :next, :previous, :surrounding_landmarks
    end
  end

  resources :comments do
    collection do
      post :collection_create
    end
  end
  resources :categories do
    collection do
      get :export
    end
    member do
      get :save_icon, :change_icon
    end
  end               

  resource :search, :controller => "search" do
    member do
      get :lookup
    end
  end
  resource :map, :controller => "map"
  resource :account, :controller => "account"
  resource :user_sessions

  resources :users, :cities, :counters, :conversions, :boundaries, :features, :samples, :audits

  resources :partners do
    resources :classifications
  end

  resources :exports do
    collection do
      get :selection
      post :count
      post :prepare
    end
  end

  resources :imports do
    member do
      get :preview
      post :execute
    end
  end

  match '/' => 'admin#dashboard'
  match '/dashboard' => 'admin#dashboard', :as => :dashboard
  match '/jobs' => 'admin#jobs', :as => :periodic_jobs
end
