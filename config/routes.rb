Gowane::Application.routes.draw do

  # Backbone API

  match "/locations/:location_id/logo" => "logos#show", :via => "get"
  match "/locations/:location_id/logo" => "logos#create", :via => "post"
  match "/locations/:location_id/logo" => "logos#delete", :via => "delete"

  match "/locations/:location_id/photos" => "photos#show", :via => "get"
  match "/locations/:location_id/photos" => "photos#create", :via => "post"
  match "/locations/:location_id/photos/:id" => "photos#delete", :via => "delete"

  match "/locations/:location_id/comments" => "comments#show", :via => "get"
  match "/locations/:location_id/comments" => "comments#create", :via => "post"

  match '/api/:action', :controller => 'api'
  match "/api/locations", :to => LocationResource, :anchor => false

  match'/locations/collection' => 'locations#collection_delete', :via => :delete
  match'/locations/collection/edit' => 'locations#collection_edit', :via => [:get]
  match'/locations/collection' => 'locations#collection_update', :via => :post

  match 'locations/landmarks' => 'landmarks#show', :as => "show_landmarks", :via => :get

  resources :locations do
    resources :tags
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
  end

  resource :search, :controller => "search" do
    member do
      get :lookup
    end
  end

  resource :map, :controller => "map"
  resource :account, :controller => "account"
  resource :user_sessions

  resources :cities do
    collection do
      post :collection_delete
    end
  end

  resources :users, :cities, :collectors, :conversions, :boundaries, :features, :samples, :audits
  resources :change_requests, :roads , :partner_categories

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
end
