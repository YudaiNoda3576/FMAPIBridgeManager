# frozen_string_literal: true

class Api::V1::BosekiInfosController < Api::V1::ApplicationController
  MEDIA_NAME = '墓石ナビ'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"name": "名前", "tel": "0120123456", "work_type": "墓じまいをしたい" }}' "http://localhost:8000/api/v1/boseki_info"

    data = Soukyakukanri.new(
      media_name: MEDIA_NAME,
      name: boseki_info_params[:name],
      tel: boseki_info_params[:tel],
      work_type: boseki_info_params[:work_type]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  end

  # rubocop:disable Metrics/AbcSize
  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": {"record_id": "245444", "cemetery_name": "本能寺" }}' "http://localhost:8000/api/v1/boseki_info"
    data = Soukyakukanri.find(boseki_info_params[:record_id])
    data.update(
      cemetery_name: boseki_info_params[:cemetery_name] || data.cemetery_name,
      cemetery_addr: boseki_info_params[:cemetery_addr] || data.cemetery_addr,
      contact_time: boseki_info_params[:addr] || data.contact_time,
      contact_note: boseki_info_params[:area] || data.contact_note,
      customer_request: boseki_info_params[:mitsumori] || data.customer_request,
      email: boseki_info_params[:email] || data.email
    )
    render json: { status: :ok, record_id: data.record_id }
  end
  # rubocop:enable Metrics/AbcSize

  private

  def boseki_info_params
    params.require(:data).permit(:record_id, :name, :tel, :work_type, :cemetery_name, :cemetery_addr, :addr, :area,
                                 :mitsumori, :email)
  end
end
