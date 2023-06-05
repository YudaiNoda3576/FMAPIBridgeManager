# frozen_string_literal: true

class Api::V1::KaitaiHikakusController < Api::V1::ApplicationController
  # TODO: メディア名をメディア計算式の値に合わせる
  MEDIA_NAME = '解体'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"building_type": "一戸建て", "addr": "北海道札幌市中央区", "name": "徳川家康", "tel": "01201234567", "mitsumori": "要望" }}' "http://localhost:8000/api/v1/kaitai_hikaku"
    data = SunlifeSoukyakukanri.new(
      media_name: MEDIA_NAME,
      building_type: kaitai_hikaku_params[:building_type],
      prefecture: kaitai_hikaku_params[:addr],
      name: kaitai_hikaku_params[:name],
      tel1: kaitai_hikaku_params[:tel],
      customer_request: kaitai_hikaku_params[:mitsumori]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def kaitai_hikaku_params
    params.require(:data).permit(:record_id, :building_type, :addr, :name, :tel,
                                 :mitsumori)
  end
end
