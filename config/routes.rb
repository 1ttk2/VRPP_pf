Rails.application.routes.draw do

  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

scope module: :public do
  root :to => 'homes#top'
  get 'homes/about' => 'homes#about'
  resources :users, only:[:index, :show, :edit, :unsubcribe, :update, :withdrawl]
  #get '/users/my_page' => 'users#my_page'
  resources :posts, only:[:edit, :show, :index, :update, :destroy, :create, :new] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  get "search_tag"=>"posts#search_tag"
  #検索結果をpostsコントローラのsearchアクションへ送信
  get 'search' => 'posts#search'
end

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
