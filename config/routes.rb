Rails.application.routes.draw do

  post '/rate' => 'rater#create', :as => 'rate'
  
  root 'main#index'
# Content pages
  get 'how_it_works', to: 'main#how_it_works'
  get 'faqs', to: 'main#faqs'
  get 'prohibited_items', to: 'main#prohibited_items'
  get 'terms_of_use', to: 'main#terms_of_use'
  get 'privacy_policy', to: 'main#privacy_policy'

  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  devise_for :users, controllers: {
                      sessions: 'sessions',
                      registrations: 'registrations',
                      :confirmations => 'confirmations',
                      omniauth_callbacks: "users/omniauth_callbacks"
                     }
  devise_scope :user do
    delete 'sign_out', :to => 'devise/sessions#destroy'
  end


#BROSING
  get '/browse', to: 'browse#index', as: 'browse'
  get '/browse_select', to: 'browse#select', as: 'browse_select'
  get '/browse/categories', to: 'browse#category', as: 'browse_categories'

#Relationships
  resources :relationships, only: [:create, :destroy]

#Gropus
  resources :groups do
    post :block_user, on: :member
    post :unblock_user, on: :member

    resources :users, only: [:show] do
    end
  end

  get 'groups_search', to: 'groups#search', as: "groups_search"
  get 'switch_groups',                  to: 'groups#switch', as: :switch_groups
  post '/choose_group/:group_id',       to: 'groups#choose_group', as: 'choose_group'
  post '/switch_group/:group_id',       to: 'groups#switch_group', as: 'switch_group'
  post '/join_group/:group_id',         to: 'groups#join_group', as: 'join_group'
  post '/leave_group/:group_id',        to: 'groups#leave_group', as: 'leave_group'
  post '/add_to_group/:user_id',        to: 'groups#add_to_group', as: 'add_to_group'
  post '/invite_to_group',              to: 'groups#invite_to_group', as: 'invite_to_group' 
  delete '/remove_from_group/:user_id', to: 'groups#remove_from_group', as: 'remove_from_group'
  post '/appoint_group_admin/:user_id', to: 'groups#appoint_admin', as: 'appoint_group_admin'
  post '/demote_group_admin/:user_id',  to: 'groups#demote_user', as: 'demote_group_admin'
  get '/more_group_items', to: 'groups#load_more', as: 'more_group_items'

#Refferal
  post 'send_invite', to: 'referral#invite', as: :send_invite
  get 'invite', to: 'referral#index', as: :invite

#FAQ
  resources :faq_items
  get 'help', to: 'faq_items#index', as: :help

# DisputsComment
  resources :disput_comments

# Disputs
  resources :disputs
  get '/open_disput_modal', to: 'disputs#open_disput_modal', as: 'open_disput_modal'
  get '/resolve_disput_modal', to: 'disputs#resolve_disput_modal', as: 'resolve_disput_modal'

# Items
  resources :items
  get 'search', to: 'items#search', as: "search"
  post '/buy_now', to: 'items#buy_now', as: 'buy_now'
  post '/buy_free', to: 'items#buy_free', as: 'buy_free'
  post '/activate_payment/:id', to: 'items#activate_payment', as: 'activate_payment'
  post '/premium_payment/:id', to: 'items#premium_payment', as: 'premium_payment'
  post '/buy_item/:id', to: 'items#buy_item', as: 'buy_item'
  post '/item/:id/offer', to: 'items#make_an_offer', as: 'make_an_offer'
  get '/items/category/:category', to: "items#index", as: "items_category"
  post 'choose_winner/:id', to: 'items#choose_winner', as: 'choose_winner'
  post 'set_winner/:id', to: 'items#set_winner', as: 'set_winner'
  post 'finish/:id', to: 'items#finish_item', as: 'finish_item'
  post 'item/:id/publish', to: 'items#publish', as: 'publish_item'
  post 'item/save_to_draft', to: 'items#save_to_draft', as: 'save_to_draft'
  patch 'item/:id/save_to_draft', to: 'items#save_to_draft', as: 'update_to_draft'
  get '/choose_posting_type', to: "items#choose_type", as: "choose_posting_type"

# Charges
  resources :charges, only: [:new, :create]

  namespace :account do
    # Messages
    post '/messages/status/:id', to: 'messages#change_status', as: 'messages_change_status'
    get '/feedback_service', to: 'messages#feedback', as: 'feedback_service'
    resources :messages, :except => [:update] do
      collection do
        delete 'destroy_multiple', to: 'messages#destroy_multiple'
      end
    end
    resources :notifications, only: [:index, :destroy]
    get '/dashboard', to: 'dashboard#index'
    get '/profile', to: 'profile#edit'
    patch '/profile', to: 'profile#update'
    get '/items', to: 'dashboard#items'
    get '/feedbacks', to: 'dashboard#feedbacks'
    get '/bids', to: 'dashboard#bids'
  end

# Likes
  put '/likes/add_to_favorite/:id/:obj', to: 'likes#add_to_favorite', as: 'add_to_favorite'
  put '/likes/remove_from_favorite/:id/:obj', to: 'likes#remove_from_favorite', as: 'remove_from_favorite'

# Photos
  post '/images/:temp_key', to: 'images#create', as: 'images_create'
  resources :images, :only => [:index, :show, :destroy]

# Bids
  resources :bids, :only => [:create]
#Feedback
  resources :feedbacks, :only => [:new, :create]

#Users
  get 'settings', to: 'users#settings', as: 'settings'
  post 'notification_permit', to: 'users#set_notification_permit', as: 'set_notification_permit'
  get 'transactions', to: 'users#transactions', as: 'transactions'
  get 'security', to: 'users#security', as: 'security'
  post '/settings/set_currency/', to: 'users#set_currency', as: 'set_currency'
  get 'my_items', to: 'users#items', as: 'my_items'
  get 'dashboard', to: 'users#dashboard'
  get 'dashboard/feedbacks', to: 'users#feedbacks'
  get 'dashboard/bids', to: 'users#bids'
  resources :users do
    collection do
      get 'new_password'
      patch 'update_password'
    end
  end
  resources :password_resets

#Balance
  resources :withdraws, :only => [:new, :create]

# Pages
  get 'pages/:id', to: 'pages#show', as: 'pages'

  get '*path' =>  redirect('/')

end
