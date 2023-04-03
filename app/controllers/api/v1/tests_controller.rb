# frozen_string_literal: true

class Api::V1::TestsController < Api::V1::ApplicationController
  def index
    #  curl "http://localhost:8000/api/v1/tests"
    tdm = TestDtbMitsumori.new(name: 'from Rails!!!')
    res = tdm.save
    render json: { status: :ok, message: res }
  end

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"name": "fuga"}' "http://localhost:8000/api/v1/tests"
    tdm = TestDtbMitsumori.new(name: params[:name]) # 本来はストロングパラメータ使ってね
    res = tdm.save
    render json: { status: :ok, message: "You send params: #{params.to_json}" }
  end
end
