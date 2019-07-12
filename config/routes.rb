Rails.application.routes.draw do
  namespace :admin do
      resources :products
      resources :reviews
      resources :users

      root to: "products#index"
    end
# For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  get('/', {to:'welcome#index', as: :root})
  get('/about', { to: 'welcome#about', as: :about })
  get('/contact_us', { to: 'contacts#index', as: :contact })
  post('/contact_us', { to: 'contacts#create' })

  patch "/reviews/:id/toggle" => "reviews#toggle_hidden", as: "toggle_hidden"


  resources :users, only: [:new, :create]
  resource :session, only: [:new, :create, :destroy]
 
  resources :products do 
    resources :reviews, only: [:create, :destroy]
  end

  resources :articles, only: [:new, :create, :show, :index, :destroy, :edit]
  resources :articles

end
