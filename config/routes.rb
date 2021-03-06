Rails.application.routes.draw do

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  root to: 'vman#index'

  get '/vman/off', :to => 'vman#off'
  get '/vman/on', :to => 'vman#on'

  #resources :currencies
  get '/currencies', :to => 'currencies#index', as: 'currencies'
  get '/currencies/:id', :to => 'currencies#index', as: 'currency_rate'

  # open positions
  resources :open_positions, only: :show, param: :date

  get '/ilya', :to => 'ilya#index', as: 'ilya'
  #match 'rates/:id' => 'rates#show', via: :get, as: 'show_rate'

  # API
  namespace :api do
    namespace :v1 do
      resource :rates do
        get :usd
      end
      resource :spot_rates do
        get :usdrub_tom
      end
      resource :dollar_index do
        get :broad
      end      
    end
  end

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
