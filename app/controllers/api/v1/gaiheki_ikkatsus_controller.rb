# frozen_string_literal: true

class Api::V1::GaihekiIkkatsusController < Api::V1::ApplicationController
  MEDIA_NAME = '外壁塗装一括net'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"position": "工事種別", "building_type": "建物の種類", "addr": "長野県松本市1-1-1", "name": "名前", "tel": "012012345678" }}' "http://localhost:8000/api/v1/gaiheki_ikkatsu"
    data = SunlifeSoukyakukanri.new(
      media_name: MEDIA_NAME,
      construction_type: gaiheki_ikkatsu_params[:position],
      building_type: gaiheki_ikkatsu_params[:building_type],
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
    params.require(:data).permit(:record_id, :position, :building_type, :addr, :name, :tel)
  end
end
