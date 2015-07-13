Rails.application.routes.draw do
  devise_for :referees

  resources :championships do
    resources :games      
    resources :players    
  end

end
