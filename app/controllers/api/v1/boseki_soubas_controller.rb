# frozen_string_literal: true

class Api::V1::BosekiSoubasController < Api::V1::ApplicationController
  MEDIA_NAME = '墓石相場net'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"cf_ctype":"新たにお墓を建てたい","cf_gyard":"わかりません", "cf_name": "名前", "cf_phone": "0120123456", "cf_pref":"東京", "cf_address":"新宿区", "cf_email":"test.mail", "cf_misc" : "100万円"}}' "http://localhost:8000/api/v1/boseki_souba"
    data = Soukyakukanri.new(
      media_name: MEDIA_NAME,
      construction_type: boseki_souba_params[:cf_ctype],
      cemetery_name: boseki_souba_params[:cf_gyard],
      name: boseki_souba_params[:cf_name],
      tel1: boseki_souba_params[:cf_phone],
      cemetery_addr: "#{boseki_souba_params[:cf_pref]} #{boseki_souba_params[:cf_address]}",
      email: boseki_souba_params[:cf_email],
      customer_request: boseki_souba_params[:cf_misc]
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
