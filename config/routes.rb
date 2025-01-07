Rails.application.routes.draw do

  resources :store_notices, only: [:index, :new, :create, :destroy]
  #resources :comunas
  resources :provinces
  resources :newsletter_subscribers
  get '/download_subscriptors', :to => 'newsletter_subscribers#download_all'
  get '/newsletter/popup', to: 'spree/home#newsletter_popup', as: :show_popup

  # This line mounts Spree's routes at the root of your application.
  # This means, any requests to URLs such as /products, will go to Spree::ProductsController.
  # If you would like to change where this engine is mounted, simply change the :at option to something different.
  #
  # We ask that you don't use the :as option here, as Spree relies on it being the default of "spree"
  mount Spree::Core::Engine, at: '/'

  get 'static_pages/new', to: 'static_pages#new', as: 'new_static_page'
  get 'static_pages/:id/destroy', to: 'static_pages#destroy', as: 'delete_static_page'
  get 'static_pages/:slug', to: 'static_pages#show', as: 'about_store'
  # get 'static_pages', to: 'static_pages#index', as: 'static_pages'
  # get 'static_pages/:id/edit', to: 'static_pages#edit', as: 'edit_static_page'
  # patch 'static_pages/:id', to: 'static_pages#update', as: 'static_pages'

  get '/dataUpload/uploadData' => 'data_upload#upload_data', as: 'upload_data'
  post '/dataUpload/import_categories' => 'data_upload#import_categories'
  post '/dataUpload/import_products' => 'data_upload#import_products'
  post '/dataUpload/import_images' => 'data_upload#import_images'
  post '/dataUpload/import_stock' => 'data_upload#import_stock'
  get '/dataUpload/uploadBanner' => 'data_upload#uploadBanner'
  post '/dataUpload/upload_banner_image' => 'data_upload#upload_banner_image'
  post '/dataUpload/delete_banner_image' => 'data_upload#delete_banner_image'
  post '/dataUpload/assign_image' => 'data_upload#assign_image'
  post '/dataUpload/import_comparable_attributes' => 'data_upload#import_comparable_attributes', as: 'import_comparable_attributes'
  post '/dataUpload/import_related_products' => 'data_upload#import_related_products'
  post '/dataUpload/import_offer_prices' => 'data_upload#import_offer_prices'
  post '/dataUpload/import_products_metadata' => 'data_upload#import_products_metadata'
  post '/dataUpload/import_categories_metadata' => 'data_upload#import_categories_metadata'
  get'/dataUpload/synchronize_products_with_miele_core' => 'data_upload#synchronize_products_with_miele_core'
  get'/dataUpload/synchronize_stock_and_price_products_with_miele_core' => 'data_upload#synchronize_stock_and_price_products_with_miele_core'

  post '/dataUpload/import_tech_documents' => 'data_upload#import_tech_documents'
  get '/dataUpload/download_categories_template' => 'data_upload#download_categories_template', :as => "categories_template_path"
  get '/dataUpload/download_products_template' => 'data_upload#download_products_template', :as => "products_template_path"
  get '/dataUpload/download_stock_template' => 'data_upload#download_stock_template', :as => "stock_template_path"
  get '/dataUpload/download_related_products_template' => 'data_upload#download_related_products_template', :as => "related_products_template_path"
  get '/dataUpload/download_offer_prices_template' => 'data_upload#download_offer_prices_template', :as => "offer_prices_template_path"
  get '/dataUpload/download_products_metadata_template' => 'data_upload#download_products_metadata_template', :as => "products_metadata_template_path"
  get '/dataUpload/download_categories_metadata_template' => 'data_upload#download_categories_metadata_template', :as => "categories_metadata_template_path"

  get '/download/stock' => 'data_upload#download_stock', as: 'download_stock'
  get '/download/products' => 'data_upload#download_products', as: 'download_products'
  get '/download/related_products' => 'data_upload#download_related_products', as: 'download_related_products'
  get '/download/offer_prices' => 'data_upload#download_offer_prices', as: 'download_offer_prices'
  get '/download/products_metadata' => 'data_upload#download_products_metadata', as: 'download_products_metadata'
  get '/download/categories_metadata' => 'data_upload#download_categories_metadata', as: 'download_categories_metadata'

  
  get 'comunas/comuna_by_region' => 'comunas#comuna_by_region'
  # Newsletter suscriber acions

  # Line items actions
  post '/lineItem/destroy_item' => 'line_item#destroy_item', :as => "line_item_destroy_item_path"


  #TagManager
  get '/tag_manager' => 'tag_manager#index'
  post '/tag_manager/update' => 'tag_manager#update'

  #WebPay
  post '/webpay/webpay_final_url', to: 'webpay#webpay_final_url', as: :webpay_result
  post '/webpay/return_url', to: 'webpay#return_url', as: :webpay_return
  post '/webpay/nullify_order', to: 'webpay#nullify_order', as: :nullify_order
  post '/user/update', to: 'local_user#update', as: :update_user
  
  resources :promotional_banners, except: [:destroy, :show]
  get 'promotional_banners/categories', to: 'promotional_banners#categories', as: 'categories_banners'
  get 'promotional_banners/categories/:taxon_id/add', to: 'promotional_banners#categories_add_banner', as: 'add_banner_to_category'

  get 'quotations/new/:product_id', to: 'quotations#new', as: 'quotation_new'
  post 'quotations', to: 'quotations#create', as: 'quotations'
  get 'quotations/success', to: 'quotations#success', as: 'success_quotation_request'

  resources :static_pages
  resources :miele_configs, only: [:index, :edit, :update]

  
  get 'admin/virtual_support', to: 'virtual_support#edit', as: :virtual_support
  patch 'admin/virtual_support', to: 'virtual_support#update'
  get 'agendamiento-cita-virtual', to: 'virtual_support#new', as: :new_virtual_support
  
  Spree::Core::Engine.routes.draw do

    get 'store_notices_controller/index'
    get 'store_notices_controller/new'

    get 'products/:id/list_prices', to: 'products#list_prices', as: 'list_product_prices'

    get 'oportunities', to: 'products#oportunities', as: 'oportunities'

    #resources :comunas
    resources :provinces
    #resources :spree_newsletter_subscribers
    namespace :admin, path: Spree.admin_path do



      resources :reports, only: [:index] do
        collection do
          get :dashboard
          get :sales_total
          get :promotions
          get :promotions_pdf
          get :sales_product_total
          get :sales_product_total_pdf
          post :sales_product_total
          get :viewed_product_total
          get :viewed_product_total_pdf
          get :loyal_customers
          get :loyal_customers_pdf
          get :customers_over_time
          get :customers_over_time_pdf
          get :visits_over_time
          get :visits_over_time_pdf
          get :visits_by_page
          get :visits_by_page_pdf
          post :sales_total
          get :searches
        end
      end
      resources :products, only: [:index] do
        collection do
          post :create_tag
          post :delete_documents
          get :documents
          get :change_state_of_product
        end
      end
      get 'configurations', :to => 'base#configurations', :as => :configurations
      get '/download_users', :to => 'users#download_users', :as => :download_users
      get '/download_new_users', :to => 'users#download_new_users', :as => :download_new_users
      get '/download_orders', :to => 'orders#download_orders', :as => :download_orders
      get '/download_orders_summary', :to => 'orders#download_orders_summary', :as => :download_orders_summary
      delete '/delete_comment/:id', :to => 'comments#destroy', :as => :delete_comment
      get '/new_users', :to => 'users#new_users', :as => :new_users

      get 'orders/:id/ready' => 'orders#ready', :as => :order_ready
      get 'orders/:id/ship' => 'orders#ship', :as => :order_ship
      get 'orders/:id/deliver' => 'orders#deliver', :as => :order_deliver
      get 'orders/update_massive_orders' => 'orders#update_massive_orders', :as => :order_update_massive_orders
      get 'orders/:id/resend_order_to_b2b' => 'orders#resend_order_to_b2b', :as => :resend_order_to_b2b

      get 'products/:id/comparable_attributes', to: 'products#comparable_attributes', as: :product_comparable_attributes
      get 'products/:id/comparable_attributes/:attribute_id/edit', to: 'products#edit_comparable_attribute', as: :edit_product_comparable_attribute
      patch 'products/:id/comparable_attributes/:attribute_id/update', to: 'products#update_comparable_attribute', as: :update_product_comparable_attribute

      get 'products/:id/specific_attributes', to: 'products#specific_attributes', as: :product_specific_attributes
      get 'products/:id/specific_attributes/:attribute_id/:attribute_name/edit/:is_boolean', to: 'products#edit_specific_attribute', as: :edit_product_specific_attribute
      patch 'products/:id/specific_attributes/:attribute_id/update', to: 'products#update_specific_attribute', as: :update_product_specific_attribute

      delete 'orders/:id', to: 'orders#destroy', as: :soft_delete_order

      get '/download_searches' => 'reports#download_searches', as: :download_searches
      get '/download_visits_by_page' => 'reports#download_visits_by_page', as: :download_visits_by_page
      get '/download_visits_over_time' => 'reports#download_visits_over_time', as: :download_visits_over_time
      get '/download_customers_over_time' => 'reports#download_customers_over_time', as: :download_customers_over_time
      get '/download_loyal_customers' => 'reports#download_loyal_customers', as: :download_loyal_customers
      get '/download_viewed_product_total' => 'reports#download_viewed_product_total', as: :download_viewed_product_total
      get '/download_sales_product_total' => 'reports#download_sales_product_total', as: :download_sales_product_total
      get '/download_promotions' => 'reports#download_promotions', as: :download_promotions
      get '/download_sales_total' => 'reports#download_sales_total', as: :download_sales_total
    end
    post 'products/fetch_stock'
    get '/products/most_selled' => 'products#most_selled'
    get 'products/recents' => 'products#recents', :as => :recents 
    get 'webpay/success', :to => 'checkout#webpay_success', :as => :webpay_success
    get 'webpay/error', :to => 'checkout#webpay_error', :as => :webpay_error
    get 'webpay/nullify', :to => 'checkout#webpay_nullify', :as => :webpay_nullify
    post 'store/newsletter' => 'store#newsletter' , :as => 'newsletter_create'
    post 'repeat/repeat_last_complete_order', :to => 'orders#repeat_last_complete_order' , :as => :repeat_last_complete_order
    post 'repeat/repeat_order', :to => 'orders#repeat_order' , :as => :repeat_order
    post 'orders/populate_ajax', :to => 'orders#populate_ajax' , :as => :populate_ajax
    post 'orders/update_ajax', :to => 'orders#update_ajax' , :as => :update_ajax
    post 'products/properties', :to => 'products#properties' , :as => :properties
    post 'orders/custom_apply_coupon', :to => 'orders#custom_apply_coupon' , :as => :custom_apply_coupon
    get 'orders/show_apply_coupon_form', to: 'orders#show_apply_coupon_form', as: :show_apply_coupon_form
    post 'orders/update_step', :to => 'orders#update_step' , :as => :update_step
    patch 'orders/update_item/quantity', to: 'orders#update_item_quantity'
    patch 'orders/update_item/installation', to: 'orders#update_item_installation'
    
    post 'orders/update/shipping_address/ajax', to: 'orders#update_shipping_address_ajax'
    post 'orders/remove_item', to: 'orders#remove_item'
    post 'orders/populate_service', to: 'orders#populate_service'
    get 'products/brands', :to => 'products#brands' , :as => :brands
    get 'taxons/get_taxon', :to => 'taxons#get_taxon' , :as => :get_taxon

    get 'products/rss' => 'products#rss', :as => :rss

    get 'store/privacy_policy', :to => 'store#privacy_policy'
    get 'store/returns_policy', :to => 'store#returns_policy'
    get 'store/maps_and_address', :to => 'store#maps_and_address'
    get 'store/about', :to => 'store#about'
    get 'store/info_delivery', :to => 'store#info_delivery'
    get '/contact', :to => 'store#new_contact', as: :contact
    post '/contact', :to => 'store#send_email_contact'
  end

  namespace :admin do
    resources :reviews, only: [:index, :destroy, :edit, :update] do
      member do
        get :approve
      end
      resources :feedback_reviews, only: [:index, :destroy]
    end
    resource :review_settings, only: [:edit, :update]
  end

  # Comparador
  post 'comparator/add_product/:variant_id', to: 'comparator#add_product', as: "comparator_add_product"
  post 'comparator/del_product', to: 'comparator#del_product', as: "comparator_del_product"

  get 'comparator', to: 'comparator#show', as: 'comparator'
  get 'comparator/download', to: 'comparator#download', as: 'comparator_download'


  # API ROUTES
  namespace :api2 do
    namespace :v1, defaults: { format: :json } do
      
      patch 'update_state_order', to: 'miele_api_for_b2b#update_state_order'
      post 'update_tracking_info_order', to: 'miele_api_for_b2b#create_or_update_tracking_info_order'
    end
  end

  #root "/"

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  ##root 'welcome#index'

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
