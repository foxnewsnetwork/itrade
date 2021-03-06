Itrade::Application.routes.draw do
	

  resources :auxiliaries, :only => [:create, :destroy, :index, :show]
	resources :targets, :only => [:index]
	resources :categories, :only => [:create, :destroy, :show, :index]
	devise_for :users, :controllers => { :sessions => "sessions", :registrations => "registrations" }
	resources :users do
		resources :locations, :only => [:create, :destroy, :update]
	end # resources
	resources :bids, :only => [:show] do
		resources :locations, :only => [:create, :destroy, :update]
	end # bids
	resources :locations do
		resources :items, :only => [:index]
		resources :bids, :only => [:index]
		resources :users, :only => [:index]
	end # locations
  resources :items do
  	resources :locations, :only => [:create, :destroy, :update]
  	resources :bids, :only => [:create, :update, :destroy, :show, :new, :edit] do
  		resources :auxiliaries, :only => [:create, :destroy, :index, :show]
  	end # resources bids
  	resources :elements, :only => [:create, :destroy]
  end # resources items  
	[:ships, :trucks].each do |transports|
		resources transports, :only => [:create, :destroy, :index]
	end # each transport	
	['admin','about'].each do |tag|
		match "/#{tag}", :to => "pages##{tag}"
	end # each tag
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'items#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
end
