Rails.application.routes.draw do
  # Auth — no registration, no password reset (single-user)
  resource :session, only: [:new, :create, :destroy]

  # Photos
  resources :photos, only: [:new, :create, :show, :edit, :update, :destroy] do
    collection do
      get  :roll          # /photos/roll — camera roll
      get  :bulk_upload
      post :bulk_upload
    end
  end

  # Calendar navigation
  get "calendar"                  => "photos#calendar", as: :calendar
  get "calendar/:year/:month"     => "photos#calendar", as: :calendar_month,
      constraints: { year: /\d{4}/, month: /\d{1,2}/ }

  get "up" => "rails/health#show", as: :rails_health_check

  root "photos#calendar"
end
