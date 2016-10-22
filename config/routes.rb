Rails.application.routes.draw do
  get 'new' => 'searches#new'
  post 'get' => 'searches#get'
  get 'image' => 'searches#get_image'
  post 'keitaiso' => 'searches#get_keitaiso'
  resources :picture_stories
end
