Psymic::Application.routes.draw do

  resources :channels do
    member do
      get 'mindlogs'
      get 'mindlogs/page/:page', :action => :mindlogs
    end
  end
  get 'channels/:id/edit/crop', to: 'channels#crop' , as: "crop_cover"


  resources :wiki_pages,:path => :wiki
  get 'confirm_email' , to: 'pages#confirm_email'
  root :to=> 'pages#root'

  namespace :meta do
    resources :feedbacks , except: :index do
      resources :comments
    end
    get '/', to: 'feedbacks#index' , as: "feedbacks"
    post '/' , to: 'feedbacks#create' , as:"feedbacks"
  end

  get 'tag::tag' , to: 'mindlogs#index' , as: :tag
  get "mindlogs/tags" => "mindlogs#tags", :as => :tags #returns json
  get 'profile' => "users#profile" , as: :profile
  get 'profile/edit' => "users#profile_edit" , as: :edit_profile
  get 'profile/edit/avatar' => "users#avatar" , as: :edit_avatar
  put 'profile/edit/avatar' => "users#update_avatar" , as: :update_avatar
  get 'profile/edit/avatar/crop' => "users#crop" , as: :crop_avatar

  resources :subscriptions do
    collection do
      get 'clear'
    end
  end

  resources :notifications do
  collection do
      get 'clear'
  end
  end

  namespace :admin do

  get 'backstage' , to: 'pages#backstage' , as: :backstage
  resources :offers
  get "reports/index"
  match "reports/:reportable_type/:reportable_id", :to=> 'reports#show', :as=> :report
  root to: 'pages#index'
  end

  resources :comments
  get 'comments/:type/:id' , to: 'comments#show' , as: "ajax_comments"

  devise_for :user, :path => 'account', :path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }
  resources :users do
    member do
      get 'mindlogs'
      get 'activity'
    end
  end

  match '/users/:id', :to => 'users#show', :as => :user


  resources :mindlogs do
    collection do
      post 'import'
      get 'autocomplete' # <= add this line
      get 'autocomplete_tags'
      get 'moderation_queue'
      get 'page/:page', :action => :index # for friendly pagination urls
    end

    member do
      get 'report'
      post 'report'
      get 'subscribe'
      post 'subscribe'
      get 'unsubscribe'
      post 'unsubscribe'
      get 'like'
      post 'like'
      get 'unlike'
      post 'unlike'
      get 'page/:page', :action => :show
    end
		resources :responses do
      member do
        get 'vote'
      end
      resources :comments
    end
	end

	match 'mindlogs/tag/:tag' => 'mindlogs#tag'
  match "/404", :to => "pages#not_found"
  match "/500", :to => "pages#error"

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
 match ':controller(/:action(/:id))(.:format)'
end
