Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :students, only: [:create, :destroy], param: :user_id

      resources :schools, only: [] do
        resources :classes, only: [:index], controller: 'classes' do
          resources :students, only: [:index], controller: 'class_students'
        end
      end
    end
  end

  get "up" => "rails/health#show", as: :rails_health_check
end