Rails.application.routes.draw do
  root :to => 'home#index'
  devise_for :referees, skip: [:sessions, :passwords, :registrations]
  
  devise_scope :referee do
    post 'signin' => 'sessions#create', :as => :referee_signin
    get 'login' => 'sessions#new', :as => :referee_login
    delete 'logout' => 'sessions#destroy', :as => :logout

    resources :championships do
      collection do
        get :dashboard
      end
      resources :games do
        resources :rounds
      end
      resources :players    
    end
  end

end
