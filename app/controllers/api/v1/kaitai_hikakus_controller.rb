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
      customer_request: kaitai_hikaku_params[:mitsumori],
      estimated_date: Time.zone.today.strftime("%m/%d/%Y")
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": {"record_id": "176297", "work_date": "できるだけ早く" }}' "http://localhost:8000/api/v1/kaitai_hikaku"
    # ページ遷移するごとにキー名が変わっていきます、area, work_date, [contact_time, contact_remark], email, 'mitsumori'
    data = SunlifeSoukyakukanri.find(kaitai_hikaku_params[:record_id])
    data.update(update_params(data))
    render json: { status: :ok, record_id: data.record_id }
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end


  private

  def kaitai_hikaku_params
    params.require(:data).permit(:record_id, :position, :building_type, :addr, :name, :tel, :area, :work_date,
                                 :contact_time, :contact_remark, :email, :mitsumori)
  end

  def update_params(data)
    { 
      area: kaitai_hikaku_params[:area] || data.area,
      work_date: kaitai_hikaku_params[:work_date] || data.work_date,
      contact_time: kaitai_hikaku_params[:contact_time] || data.contact_time,
      contact_note: kaitai_hikaku_params[:contact_remark] || data.contact_note,
      email: kaitai_hikaku_params[:email] || data.email,
      customer_request: kaitai_hikaku_params[:mitsumori] || data.customer_request
    }
  end
end
