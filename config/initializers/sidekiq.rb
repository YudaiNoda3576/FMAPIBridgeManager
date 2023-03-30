# frozen_string_literal: true

unless Rails.env.test?
  host = ENV.fetch('REDIS_HOST', nil)
  port = ENV.fetch('REDIS_PORT', nil)
  SIDEKIQ_DB = 9

  sidekiq_url = "redis://#{host}:#{port}/#{SIDEKIQ_DB}"

  Sidekiq.configure_server do |config|
    config.redis = { url: sidekiq_url }
  end

  Sidekiq.configure_client do |config|
    config.redis = { url: sidekiq_url }
  end
end
