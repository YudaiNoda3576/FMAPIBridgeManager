# frozen_string_literal: true

class Api::V1::YanekoujiInfosController < Api::V1::ApplicationController
  MEDIA_NAME = '屋根'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"position": "工事種別", "addr": "東京都新宿区1-1-1", "name": "名前", "tel": "012012345678" }}' "http://localhost:8000/api/v1/yanekouji_info"
    data = SunlifeSoukyakukanri.new(
      media_name: MEDIA_NAME,
      construction_type: yanekouji_info_params[:position],
      prefecture: yanekouji_info_params[:addr],
      name: yanekouji_info_params[:name],
      tel1: yanekouji_info_params[:tel]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": { "record_id": "245535", "area": "100"}}' "http://localhost:8000/api/v1/yanekouji_info"
    # ページ遷移するごとにキー名が変わっていきます、area, work_date, [contact_time, contact_remark], email, mitsumori
    data = SunlifeSoukyakukanri.find(yanekouji_info_params[:record_id])
    data.update(update_params(data))
    render json: { status: :ok, record_id: data.record_id }
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def yanekouji_info_params
    params.require(:data).permit(:record_id, :position, :addr, :name, :tel, :area, :work_date, :contact_time, :contact_remark, :email, :mitsumori)
  end

  def update_params(data)
    {
      area: yanekouji_info_params[:area] || data.area,
      work_date: yanekouji_info_params[:work_date] || data.work_date,
      contact_time: yanekouji_info_params[:contact_time] || data.contact_time,
      contact_note: yanekouji_info_params[:contact_remark] || data.contact_note,
      email: yanekouji_info_params[:email] || data.email,
      customer_request: yanekouji_info_params[:mitsumori] || data.customer_request
    }
  end
end
