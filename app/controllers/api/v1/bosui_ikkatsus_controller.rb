# frozen_string_literal: true

class Api::V1::BosuiIkkatsusController < Api::V1::ApplicationController
  MEDIA_NAME = '防水工事セレクトナビ'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"position": "ベランダの防水工事", "building_type": "一戸建て住宅", "addr": "愛知県名古屋市1-1-1", "name": "名前", "tel": "0120123456" }}' "http://localhost:8000/api/v1/bosui_ikkatsu"
    data = Soukyakukanri.new(
      media_name: MEDIA_NAME,
      construction_type: bosui_ikkatsu_params[:position],
      building_type: bosui_ikkatsu_params[:building_type],
      prefecture: bosui_ikkatsu_params[:addr],
      name: bosui_ikkatsu_params[:name],
      tel1: bosui_ikkatsu_params[:tel]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": {"record_id": "245530", "work_date": "できるだけ早く" }}' "http://localhost:8000/api/v1/bosui_ikkatsu"
    # ページ遷移するごとにキー名が変わっていきます、work_date, [contact_time, contact_remark], email, 'mitsumori'
    data = Soukyakukanri.find(bosui_ikkatsu_params[:record_id])
    data.update(update_params(data))
    render json: { status: :ok, record_id: data.record_id }
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def bosui_ikkatsu_params
    params.require(:data).permit(:record_id, :position, :building_type, :addr, :name, :tel, :work_date,
                                 :contact_time, :contact_remark, :email, :mitsumori)
  end

  def update_params(data)
    {
      work_date: bosui_ikkatsu_params[:work_date] || data.work_date,
      contact_time: bosui_ikkatsu_params[:contact_time] || data.contact_time,
      contact_note: bosui_ikkatsu_params[:contact_remark] || data.contact_note,
      email: bosui_ikkatsu_params[:email] || data.email,
      customer_request: bosui_ikkatsu_params[:mitsumori] || data.customer_request
    }
  end
end
