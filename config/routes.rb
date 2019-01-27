Rails.application.routes.draw do
  get '/play', to: 'characters#play'
  post '/play', to: 'characters#character_play'
  post '/searchByLetter', to: 'characters#searchByLetter'
  root 'characters#play'

  resources :characters, only: [:index]
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
