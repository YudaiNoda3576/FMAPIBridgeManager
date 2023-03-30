# frozen_string_literal: true

class Api::V1::TestsController < Api::V1::ApplicationController
  def index
    #  curl "http://localhost:8000/api/v1/tests"
    render json: { status: :ok, message: 'test' }
  end

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"hoge": "fuga"}' "http://localhost:8000/api/v1/tests"
    render json: { status: :ok, message: "You send params: #{params.to_json}" }
  end
end
