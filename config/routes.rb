Rails.application.routes.draw do
  root 'picture_stories#home'
  resources :picture_stories
end
