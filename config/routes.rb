Blogembed::Application.routes.draw do
  devise_for :users

  resources :users, only: [] do
    resources :blogs, only: [:index, :new, :create, :update, :destroy, :edit] do
      resources :posts
      resources :settings, only: [:edit, :update]
      resources :embeds, only: [:index, :show]
    end
  end

  get 'blog' => 'moonblog#index', as: 'moonblog'

  root 'welcome#index'
end
