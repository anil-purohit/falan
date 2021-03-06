require 'api_constraints'

Rails.application.routes.draw do
  namespace :admin do
    resources :books
    resources :user_books
    get '/' => 'user_books#index'
  end

  root 'welcome#index'

  # APIs for interacting with falan system.
  namespace :api, :defaults => {:format => :json} do
    scope :module => :v1, :constraints => ApiConstraints.new(:version => 1, :default => true) do
      resources :users, :only => [:show, :create]
      resources :user_books, :only => [:create]
      resource :requests, :only => [:create]
      get "requests/all/:user_id" => "requests#get_all"
      post "requests/accept" => "requests#accept"
      post "requests/reject" => "requests#reject"
      post "/user_books/delete" => "user_books#delete"
      post "/user_books/update-status" => "user_books#update_status"
      post "/user/update-location" => "users#update_user_location"
      get "search/:id" => "search#search_books_of_user"
      get "home/search/:id" => "search#home_page_search"
    end
  end


























  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
