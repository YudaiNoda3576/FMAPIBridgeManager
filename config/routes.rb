# frozen_string_literal: true

require 'sidekiq/web'
Rails.application.routes.draw do
  mount Sidekiq::Web, at: '/sidekiq'

  namespace 'api' do
    namespace 'v1' do
      resources :tests, only: %i[index create]
      resource :boseki_info, only: %i[create update]
      resource :gaiheki_info, only: %i[create update]
      resource :bosui_ikkatsu, only: %i[create update]
      resource :gaiheki_ikkatsu, only: %i[create update]
      resource :yanekouji_info, only: %i[create update]
      resource :kaitaikoji_net, only: %i[create]
      resource :boseki_souba, only: %i[create]
      resource :genjo_hikaku, only: %i[create update]
      resource :reform_mitsumori, only: %i[create update]
      resource :kaitai_hikaku, only: %i[create]
      resource :reien_info, only: %i[create]
      resource :bosui, only: %i[create update]
      get 'debug/records_by_media_name', to: 'debug#records_by_media_name'
    end
  end
end
