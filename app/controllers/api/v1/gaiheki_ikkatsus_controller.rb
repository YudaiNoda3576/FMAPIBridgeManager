# frozen_string_literal: true

class Api::V1::GaihekiIkkatsusController < Api::V1::ApplicationController
  MEDIA_NAME = '外壁塗装一括net'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"addr": "長野県松本市1-1-1", "name": "名前", "tel": "012012345678" }}' "http://localhost:8000/api/v1/gaiheki_ikkatsu"
    data = SunlifeSoukyakukanri.new(
      media_name: MEDIA_NAME,
      prefecture: gaiheki_ikkatsu_params[:addr],
      name: gaiheki_ikkatsu_params[:name],
      tel1: gaiheki_ikkatsu_params[:tel]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def gaiheki_ikkatsu_params
    params.require(:data).permit(:record_id, :addr, :name, :tel, :building_type, :position, :work_date, :contact_time, :contact_remark, :email, :mitsumori)
  end
end
