# frozen_string_literal: true

class Api::V1::ApplicationController < ApplicationController
  skip_before_action :verify_authenticity_token
end
