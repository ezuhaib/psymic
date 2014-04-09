Psymic::Application.routes.draw do

#######################
# COMICS
#######################
resources :comics do
  get 'like' , on: :member , as: :like
end

#######################
# CHANNELS
#######################
resources :channels do
  collection do
    get 'autocomplete'
  end
  member do
    get 'queue/:item' , action: :item , as: :item
    get 'queue'
    get 'mindlogs'
    get 'mindlogs/page/:page', action: :mindlogs
  end
end
get 'channels/:id/edit/crop', to: 'channels#crop' , as: "crop_cover"

#######################
# ADMIN
#######################

namespace :admin do
  get 'channel_items' => 'pages#channel_items' , as: :channel_items
  get 'users'=> 'pages#users' , as: :users
  get 'backstage' => 'pages#backstage' , as: :backstage
  get 'comics' => 'pages#comics' , as: :comics
  get "reports/index"
  get "reports/:reportable_type/:reportable_id" => 'reports#show', :as=> :report
  resources :offers
  root to: 'pages#index'
end

#######################
# COMMENTS
#######################
resources :comments
get 'comments/:type/:id' , to: 'comments#show' , as: "ajax_comments"

#######################
# MESSAGES
#######################
resources :messages , except: :show do
  get 'user/:username', action: :show , on: :collection , as: :user
end

#######################
# WIKI_PAGES
#######################
resources :wiki_pages,:path => :wiki

#######################
# META
#######################
namespace :meta do
  resources :feedbacks , except: :index do
    resources :comments
  end
  get '/', to: 'feedbacks#index' , as: "feedbacks"
  post '/' , to: 'feedbacks#create' , as:"feedbacks"
end

#######################
# MINDLOGS
#######################
resources :mindlogs , except: :index do
  collection do
    post 'import'
    get 'autocomplete'
    get 'autocomplete_tags'
    get 'moderation_queue'
    get 'page/:page', :action => :index # for friendly pagination urls
  end

  member do
    get 'channels/add' , action: 'channel_selection' , as: 'channels'
    get 'report'
    post 'report'
    get 'subscribe'
    post 'subscribe'
    get 'unsubscribe'
    post 'unsubscribe'
    get 'page/:page', :action => :show
    get 'rate'
    get 'resolve'
  end
  resources :responses do
    member do
      get 'vote'
    end
    resources :comments
  end
end
get "mindlogs/tags" => "mindlogs#tags", :as => :tags #returns json
match 'mindlogs/tag/:tag' => 'mindlogs#tag'

#######################
# NOTIFICATIONS
#######################
resources :notifications do
  collection do
      get 'clear'
  end
end

#######################
# PROFILES
#######################
get 'profile' => "users#profile" , as: :profile
get 'profile/edit' => "users#profile_edit" , as: :edit_profile
get 'profile/edit/avatar' => "users#avatar" , as: :edit_avatar
put 'profile/edit/avatar' => "users#update_avatar" , as: :update_avatar
get 'profile/edit/avatar/crop' => "users#crop" , as: :crop_avatar

#######################
# STATIC
#######################
match "/404", :to => "pages#not_found"
match "/500", :to => "pages#error"

#######################
# SUBSCRIPTIONS
#######################
resources :subscriptions do
  collection do
    get 'clear'
  end
end

#######################
# TAGS
#######################
get 'tag::tag' , to: 'tags#show' , as: :tag

#######################
# USERS
#######################
devise_for :user,
:path => 'account',
:path_names => { :sign_in => "login", :sign_out => "logout", :sign_up => "register" }
resources :users do
  collection do
    get 'autocomplete'
  end
  member do
    get 'mindlogs'
    get 'activity'
  end
end
get 'confirm_email' , to: 'pages#confirm_email'
match '/users/:id', :to => 'users#show', :as => :user

#######################
# UPDATES
#######################
resources :updates

#######################
# :)
#######################
root :to=> 'pages#root'
match ':controller(/:action(/:id))(.:format)'
end
