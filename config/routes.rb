Rails.application.routes.draw do
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  resources :impressions

  ###########
  # admin routes
  ###########
  namespace :admin do
    resources :business_categories
    
    resources :businesses do
      resources :gallery_photos, only: [ :new, :create]
      member do
        patch :ban
        patch :verify
        patch :change_featured_status
        get :invite_page_admin
        post :send_admin_invitation
        get :request_ownership_transfer
        patch :transfer_ownership
      end
    end
    resources :admins do
      member do
        patch :activate_deactivate
        patch :reset_password
      end
    end
    resources :users, only: [:index, :show] do
      member do
        patch :ban
      end
    end
    resources :slider_images
    resources :artists do
      resources :gallery_photos, only: [ :new, :create]
      member do
        patch :change_status
        patch :change_featured_status
        patch :verify
        get :invite_page_admin
        post :send_admin_invitation
        get :request_ownership_transfer
        patch :transfer_ownership
      end
    end
    resources :awards, :events, :gallery_photos, :life_events, :news_stories, :collection_albums, :blogs, :songs, :books, :photo_arts, :productions, :suggested_updates, except: [:new, :delete] do
      member do
        patch :change_status
        patch :ban
      end
    end

    resources :events do
      member do
        patch :change_featured_status
      end
    end
    resources :sites

    resources :site_ads
    get 'dashboard' => 'pages#dashboard'
    post 'login' => 'sessions#create'
    delete 'logout' => 'sessions#destroy'

    root 'sessions#new'
  end

  resources :users, shallow: :true do
    resources :artists, only: [:new, :create]
    resources :businesses, only: [:new, :create]
    member do
      get :confirm_email
      get :dashboard
      get :accept_admin_invitation
      get :confirm_email
      get 'edit_profile_pic' => 'users#edit_profile_pic'
      get 'fanned_artists'
      get 'liked_businesses'
      get 'entity_management'
    end
  end

  #sign_up routes
  get 'signup' => 'users#new'

  # Sessions routes
  get 'login' => 'sessions#new'
  post 'login' => 'sessions#create'
  delete 'logout' => 'sessions#destroy'
  get 'logout' => 'sessions#destroyuser'

  get 'load_specialities' => 'artists#load_specialities'
  get 'terms_and_conditions' => 'pages#terms_and_conditions'
  get 'privacy' => 'pages#privacy'
  get 'about' => 'pages#about'
  get 'help' => 'pages#help'

  # autocomplete routes
  get 'autocomplete_director_name' => 'productions#get_directors'
  get 'autocomplete_production_company_name' => 'productions#get_production_companies'
  get 'autocomplete_production_language' => 'productions#get_production_languages'
  get 'autocomplete_publishing_company_name' => 'books#get_publishing_companies'
  get 'autocomplete_event_venues' => 'events#get_venues'

  get 'autocomplete_nominee/:award_category_id' => 'nominees#get_nominee', as: :autocomplete_nominee

  get 'search' => 'search#get_results', as: :search
  get 'music_artist_listings' => 'artists#music_artist_listings', as: :music_artist_listings
  get 'photo_art_artist_listings' => 'artists#photo_art_artist_listings', as: :photo_art_artist_listings
  get 'fashion_artist_listings' => 'artists#fashion_artist_listings', as: :fashion_artist_listings
  get 'literature_artist_listings' => 'artists#literature_artist_listings', as: :literature_artist_listings
  get 'production_artist_listings' => 'artists#production_artist_listings', as: :production_artist_listings

  get 'artist_listings' => 'artists#artist_listings', as: :artist_listings
  get 'business_listings' => 'businesses#business_listings', as: :business_listings
  get 'item_listings' => 'search#item_listings', as: :item_listings
  get 'media_listings' => 'media#media_listings', as: :media_listings
  get 'awards_listings' => 'awards#awards_listings', as: :awards_listings

  get 'music' => 'songs#music_dashboard', as: :music_dashboard
  get 'arts' => 'photo_arts#photo_arts_dashboard', as: :photo_arts_dashboard
  get 'fashion' => 'artists#fashion_dashboard', as: :fashion_dashboard
  get 'literature' => 'books#literature_dashboard', as: :literature_dashboard
  get 'film' => 'productions#productions_dashboard', as: :productions_dashboard
  get 'business' => 'businesses#businesses_dashboard', as: :businesses_dashboard
  get 'events' => 'events#events_dashboard', as: :events_dashboard
  get 'media' => 'media#media_dashboard', as: :media_dashboard
  get 'awards' => 'awards#awards_dashboard', as: :awards_dashboard
  get 'deletephoto/:id' => 'gallery_photos#destroy'
  get "presskit" => 'artists#presskit', as: :presskit
  get "deactivate/:id" => 'users#ban', as: :deactivate

  root 'pages#homepage'

  resources :artists, path: "" do
    member do
      get 'add_remove_fan'
    end
  end

  resources :businesses, path: "/business" do
    member do
      get 'add_remove_fan'
    end
  end

  resources :artists, :businesses, shallow: :true do
    collection do
      get :token_inputs
    end
      resources :events, :life_events, :news_stories, :blogs, only: [:new, :create],  shallow: :true do
      resources :gallery_photos
    end

    resources :songs, only: [:new, :create]
    resources :books, only: [:new, :create]
    resources :photo_arts, only: [:new, :create]
    resources :productions, only: [:new, :create]
    resources :links
    resources :collection_albums
    resources :suggested_updates
    member do
      get :invite_page_admin
      post :send_admin_invitation
      get :request_ownership_transfer
      patch :transfer_ownership
      get :contacts
      get :book_token_inputs
      get :production_token_inputs
      get :song_token_inputs
      get :photo_art_token_inputs
      get :award_token_inputs
      get :collection_album_token_inputs
    end
  end

  resources :awards, shallow: :true do
    collection do
      get :token_inputs
    end
  end

  resources :businesses, shallow: :true do
    member do
      get 'add_remove_fan'
    end
    resources :artists
    resources :awards, shallow: :true do
    resources :gallery_photos
      member do
        get :show_awards_categories
        resources :award_categories, shallow: :true do
          member do
            resources :nominees
          end
        end
      end
    end
  end

  resources :events, :gallery_photos, :life_events, :news_stories, :blogs, :songs, :books, :photo_arts, :productions do
    member do
      get :publish
    end
    collection do
      get :token_inputs
    end
    get :publish
  end

  #this is for adding entities
  resources :artists do
    member do
      get :new_link
      post :create_link
      get :new_life_event
      post :create_life_event
      get :new_entity
      post :create_entity
      get :new_news_event_blog
      post :create_news_event_blog
      get :create_news_event_blog
      get :publish
    end
    get :publish
    resources :gallery_photos, only: [:new, :create]
  end

  resources :businesses do
    member do
      get :new_news_event_blog
      post :create_news_event_blog
      get :new_link
      post :create_link
      get :new_entity
      post :create_entity
    end
    resources :gallery_photos, only: [:new, :create]
  end
  #########

  resources :password_resets

  #omniauth routing
  get '/auth/:provider/callback', to: 'sessions#omniauth_create', as: 'omniauth_create'

  match '*a', :to => redirect('/'), via: [:get, :post]
end
