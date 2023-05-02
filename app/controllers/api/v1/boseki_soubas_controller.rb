# frozen_string_literal: true

class Api::V1::BosekiSoubasController < Api::V1::ApplicationController
  MEDIA_NAME = '墓石相場net'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"cf_ctype":"新たにお墓を建てたい","cf_gyard":"わかりません", "cf_name": "名前", "cf_phone": "0120123456", "cf_pref":"東京", "cf_address":"新宿区", "cf_email":"test.mail", "cf_misc" : "100万円"}}' "http://localhost:8000/api/v1/boseki_souba"
    data = SunlifeSoukyakukanri.new(
      media_name: MEDIA_NAME,
      cf_ctype: boseki_souba_params[:construction_type],
      cf_gyard: boseki_souba_params[:cemetery_name],
      cf_name: boseki_souba_params[:name],
      cf_phone: boseki_souba_params[:tel1],
      cemetery_addr: "#{boseki_souba_params[:cf_pref]} #{boseki_souba_params[:cf_address]}",
      cf_email: boseki_souba_params[:email],
      cf_misc: boseki_souba_params[:customer_request]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def boseki_souba_params
    params.require(:data).permit(:record_id, :cf_ctype, :cf_gyard, :cf_name,
                                 :cf_phone, :cf_pref, :cf_address, :cf_email, :cf_misc)
  end
end
