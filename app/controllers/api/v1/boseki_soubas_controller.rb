# frozen_string_literal: true

class Api::V1::BosekiSoubasController < Api::V1::ApplicationController
  # TODO: メディア名をメディア計算式の値に合わせる
  MEDIA_NAME = '墓石'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"cf_ctype":"新たにお墓を建てたい","cf_gyard":"わかりません", "cf_name": "名前", "cf_phone": "0120123456", "cf_pref":"東京", "cf_address":"新宿区", "cf_email":"test.mail", "cf_misc" : "100万円"}}' "http://localhost:8000/api/v1/boseki_souba"
    data = SunlifeSoukyakukanri.new(
      media_name: MEDIA_NAME,
      work_type: boseki_souba_params[:cf_ctype],
      cemetery_name: boseki_souba_params[:cf_gyard],
      name: boseki_souba_params[:cf_name],
      tel1: boseki_souba_params[:cf_phone],
      cemetery_addr: boseki_souba_params[:cf_pref],
      email: boseki_souba_params[:cf_email],
      customer_request: boseki_souba_params[:cf_misc],
      estimated_date: Time.zone.today.strftime("%m/%d/%Y")
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  def update
    data = SunlifeSoukyakukanri.find(boseki_souba_params[:record_id])
    data.update(update_params(data))
    render json: { status: :ok, record_id: data.record_id } 
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def boseki_souba_params
    params.require(:data).permit(:record_id, :cf_ctype, :cf_gyard, :cf_name,
                                 :cf_phone, :cf_pref, :cf_address, :cf_email, :cf_misc, :cf_contact_time, :cf_contact_remark, :mitsumori, :contact_time, :contact_remark, :email, :work_date, :cemetery_addr)
  end

  def update_params(data)
    {
      cemetery_addr: "#{data.cemetery_addr}#{boseki_souba_params[:cf_address] || boseki_souba_params[:cemetery_addr]}" || data.cemetery_addr,
      contact_time: boseki_souba_params[:cf_contact_time] || boseki_souba_params[:contact_time] || data.contact_time,
      contact_note: boseki_souba_params[:cf_contact_remark] || boseki_souba_params[:contact_remark] ||data.contact_note,
      email: boseki_souba_params[:cf_email] || boseki_souba_params[:email] || data.email,
      customer_request: boseki_souba_params[:cf_misc] || boseki_souba_params[:mitsumori] || data.customer_request,
      work_date: boseki_souba_params[:cf_ctype] || boseki_souba_params[:work_date] || data.work_date,
    }
  end
end
