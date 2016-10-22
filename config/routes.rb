Rails.application.routes.draw do
  get 'new' => 'searches#new'
  post 'get' => 'searches#get'
end
