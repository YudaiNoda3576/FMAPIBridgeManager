# frozen_string_literal: true

class Api::V1::BosuiLargesController < Api::V1::ApplicationController
  # TODO: メディア名をメディア計算式の値に合わせる
  MEDIA_NAME = '防水'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"building_type": "アパート", "position": "屋上", "area": "100平米","addr": "岐阜県岐阜市1-1-1", "name": "斉藤道三", "kana": "さいとうどうさん",  "tel1": "0120123456", "tel2": "0120123456", "email": "test@test"}}' "http://a:a@localhost:8000/api/v1/bosui_large"
    data = SaftaSoukyakukanri.new(
      media_name: MEDIA_NAME,
      building_type: bosui_large_params[:building_type],
      construction_type: bosui_large_params[:position],
      area: bosui_large_params[:area],
      prefecture: bosui_large_params[:addr],
      customer_request: bosui_large_params[:mitsumori],
      name: bosui_large_params[:name],
      kana: bosui_large_params[:kana],
      tel1: bosui_large_params[:tel1],
      tel2: bosui_large_params[:tel2],
      email: bosui_large_params[:email],
      chat: bosui_large_params[:chat],
      estimated_date: Time.zone.today.strftime("%m/%d/%Y")
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def bosui_large_params
    params.require(:data).permit(:record_id, :addr, :name, :building_type, :position, :area, :email, :kana, :tel1, :tel2, :mitsumori, :chat)
  end
end
