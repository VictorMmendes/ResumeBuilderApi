Rails.application.routes.draw do
  resources :resumes do
    get :export, on: :member
    post :avatar, on: :member

    resources :educations, shallow: true
    resources :top_skills, shallow: true
    resources :certifications, shallow: true
    resources :experience_groups, shallow: true do
      resources :experience_positions, shallow: true do
        resources :experience_position_bullets, shallow: true
      end
    end
  end
  resources :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
