# frozen_string_literal: true

class Api::V1::ApplicationController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :basic_auth

  private

  def basic_auth
    return unless ENV.fetch('BASIC_USER', nil).nil? || ENV.fetch('BASIC_PASS', nil).nil?

    authenticate_or_request_with_http_basic do |username, password|
      username == ENV.fetch('BASIC_USER', nil) && password == ENV.fetch('BASIC_PASS', nil)
    end
  end
end
