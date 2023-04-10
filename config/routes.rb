# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  namespace 'api' do
    namespace 'v1' do
      resources :tests, only: %i[index create]
      resource :boseki_info, only: %i[create update]
      resource :kaitai_hikaku, only: %i[create]
      get 'debug/show_env', to: 'debug#show_env'
    end
  end
end
