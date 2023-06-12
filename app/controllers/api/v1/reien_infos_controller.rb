# frozen_string_literal: true

class Api::V1::ReienInfosController < Api::V1::ApplicationController
  # TODO: メディア名をメディア計算式の値に合わせる
  MEDIA_NAME = '霊園'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"name": "名前", "tel": "0120123456" }}' "http://localhost:8000/api/v1/reien_info"
    data = SaftaSoukyakukanri.new(
      media_name: MEDIA_NAME,
      name: reien_info_params[:name],
      tel1: reien_info_params[:tel],
      estimated_date: Time.zone.today.strftime("%m/%d/%Y")
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def reien_info_params
    params.require(:data).permit(:record_id, :name, :tel)
  end
end
