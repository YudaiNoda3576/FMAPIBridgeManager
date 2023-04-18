# frozen_string_literal: true

class Api::V1::KaitaikojiNetsController < Api::V1::ApplicationController
  MEDIA_NAME = '解体工事比較ナビ'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"building_type": "アパート", "floor": "3", "area": "20", "addr": "東京都板橋区1-11-1", "name": "織田信長", "tel": "0120123456", "email": "hogehoge@hoge.com", "mitsumori": "aaaaa" }}' "http://localhost:8000/api/v1/kaitaikoji_net"
    data = Soukyakukanri.new(
      media_name: MEDIA_NAME,
      building_type: kaitaikoji_net_params[:building_type],
      floor: kaitaikoji_net_params[:floor],
      area: kaitaikoji_net_params[:area],
      prefecture: kaitaikoji_net_params[:addr],
      name: kaitaikoji_net_params[:name],
      tel1: kaitaikoji_net_params[:tel],
      email: kaitaikoji_net_params[:email],
      customer_request: kaitaikoji_net_params[:mitsumori]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def kaitaikoji_net_params
    params.require(:data).permit(:record_id, :building_type, :floor, :area, :addr, :name, :tel, :email,
                                 :mitsumori)
  end
end
