Rails.application.routes.draw do
  get '/search', to: 'characters#search'
  post '/search', to: 'characters#character_search'
  root 'characters#play'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
