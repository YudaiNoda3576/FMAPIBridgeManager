# frozen_string_literal: true

class Api::V1::BosuisController < Api::V1::ApplicationController
  MEDIA_NAME = '防水工事セレクトナビ'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"addr": "愛知県名古屋市中区1-1-1", "name": "織田信長", "tel": "0120123456" }}' "http://localhost:8000/api/v1/bosui"
    data = SaftaSoukyakukanri.new(
      media_name: MEDIA_NAME,
      prefecture: bosui_params[:addr],
      name: bosui_params[:name],
      tel1: bosui_params[:tel]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": {"record_id": "245586", "building_type": "本能寺" }}' "http://localhost:8000/api/v1/bosui"
    # ページ遷移するごとにキー名が変わっていきます、bilding_type, position, area, email, mitsumori
    data = SaftaSoukyakukanri.find(bosui_params[:record_id])
    data.update(update_params(data))
    render json: { status: :ok, record_id: data.record_id }
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def bosui_params
    params.require(:data).permit(:record_id, :addr, :name, :tel, :building_type, :position, :area, :email, :mitsumori)
  end

  def update_params(data)
    {
      building_type: bosui_params[:building_type] || data.building_type,
      construction_type: bosui_params[:position] || data.construction_type,
      area: bosui_params[:area] || data.area,
      email: bosui_params[:email] || data.email,
      customer_request: bosui_params[:mitsumori] || data.customer_request
    }
  end
end
