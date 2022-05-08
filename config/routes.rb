Rails.application.routes.draw do

scope module: :public do
  root :to => 'homes#top'
  get 'homes/about' => 'homes#about'
  resource :user, only:[:index, :show, :edit, :unsubcribe, :update, :withdrawl]
  get '/users/my_page' => 'users#show'
  resources :posts, only:[:edit, :show, :index, :update, :destroy, :create, :new]
  get "search_tag"=>"posts#search_tag"
end


  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
