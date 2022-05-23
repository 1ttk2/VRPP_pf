Rails.application.routes.draw do
  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions',
    #Twitter API認証用
    :omniauth_callbacks => 'public/omniauth_callbacks',
  }
scope module: :public do
  root :to => 'homes#top'
  get 'homes/about' => 'homes#about'
  resources :users, only:[:index, :show, :edit, :unsubcribe, :update, :withdrawl, :destroy]
  #get '/users/my_page' => 'users#my_page'
  resources :posts, only:[:edit, :show, :index, :update, :destroy, :create, :new] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
  get "search_tag"=>"posts#search_tag"
  get 'search' => 'posts#search' #検索結果をpostsコントローラのsearchアクションへ送信
  get '/users/:id/unsubscribe' => 'users#unsubscribe', as: 'unsubscribe' #退会確認画面
  patch '/users/:id/withdrawal' => 'users#withdrawal', as: 'withdrawal' #論理削除用のルーティング
end
  namespace :admin do
   resources :users, only:[:index, :show, :edit, :update, :destroy]
   resources :posts, only:[:edit, :show, :index, :update, :destroy, :create, :new] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy]
  end
   get "search_tag"=>"posts#search_tag"
   get 'search' => 'posts#search' #検索結果をpostsコントローラのsearchアクションへ送信
  end
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
