# frozen_string_literal: true

#  TODO: Remove this controller before production
class Api::V1::DebugController < Api::V1::ApplicationController
  def show_env
    render json: { redis_host: ENV.fetch('REDIS_HOST', nil), redis_port: ENV.fetch('REDIS_PORT', nil), rails_env: ENV.fetch('RAILS_ENV', nil), redis_url: ENV.fetch('REDIS_URL', nil) }
  end
end
