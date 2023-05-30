# frozen_string_literal: true

class Api::V1::TestsController < Api::V1::ApplicationController
  def index
    #  curl "http://localhost:8000/api/v1/tests"
    res = TestDtbMitsumori.all
    binding.pry
    render json: { status: :ok, message: "You send params: #{params.to_json}", data: res}
  end

  def show
    # curl "http://localhost:8000/api/v1/tests/1"
    res = TestDtbMitsumori.find(params[:id])
    render json: { status: :ok, message: "You send params: #{params.to_json}", data: res}
  end

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"name": "fuga"}' "http://localhost:8000/api/v1/tests"
    tdm = TestDtbMitsumori.new(name: params[:name]) # 本来はストロングパラメータ使ってね
    res = tdm.save
    render json: { status: :ok, message: "You send params: #{params.to_json}" }
  end

  def update
    # curl -X PUT -H 'Content-Type: application/json' -d '{"name": "hoge"}' "http://localhost:8000/api/v1/tests/1"
    test_dtb_mitsumori = TestDtbMitsumori.find(params[:id])
    test_dtb_mitsumori.name = 'Updated Record'
    test_dtb_mitsumori.save
  end

  def destroy
    # curl -X DELETE "http://localhost:8000/api/v1/tests/1"
    test_dtb_mitsumori = TestDtbMitsumori.find(params[:id])
    test_dtb_mitsumori.destroy
  end

end
