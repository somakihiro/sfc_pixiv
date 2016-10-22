Rails.application.routes.draw do
  get 'new' => 'searches#new'
  post 'get' => 'searches#get'
  get 'image' => 'searches#get_image'
  get 'keitaiso' => 'searches#get_keitaiso'
  resources :picture_stories
end
