# frozen_string_literal: true

class Api::V1::KaitaikojiNetsController < Api::V1::ApplicationController
  # TODO: メディア名をメディア計算式の値に合わせる
  MEDIA_NAME = '解体'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"addr": "愛知県名古屋市中区1-1-1", "name": "織田信長", "tel": "0120123456" }}' "http://localhost:8000/api/v1/kaitaikoji_net"
    data = SaftaSoukyakukanri.new(
      media_name: MEDIA_NAME,
      prefecture: kaitaikoji_net_params[:addr],
      name: kaitaikoji_net_params[:name],
      tel1: kaitaikoji_net_params[:tel]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": {"record_id": "245586", "building_type": "マンション" }}' "http://localhost:8000/api/v1/kaitaikoji_net"
    # ページ遷移するごとにキー名が変わっていきます、bilding_type, position, area, email, mitsumori
    data = SaftaSoukyakukanri.find(kaitaikoji_net_params[:record_id])
    data.update(update_params(data))
    render json: { status: :ok, record_id: data.record_id }
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def kaitaikoji_net_params
    params.require(:data).permit(:record_id, :addr, :name, :tel, :building_type, :position, :area, :email, :mitsumori)
  end

  def update_params(data)
    {
      building_type: kaitaikoji_net_params[:building_type] || data.building_type,
      construction_type: kaitaikoji_net_params[:position] || data.construction_type,
      area: kaitaikoji_net_params[:area] || data.area,
      email: kaitaikoji_net_params[:email] || data.email,
      customer_request: kaitaikoji_net_params[:mitsumori] || data.customer_request
    }
  end
end
