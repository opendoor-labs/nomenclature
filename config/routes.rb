Rails.application.routes.draw do
  root 'public#index'
  post '/nom', to: 'noms#nom'
  post '/define', to: 'noms#define'
  get '/install', to: 'install#install'
end
