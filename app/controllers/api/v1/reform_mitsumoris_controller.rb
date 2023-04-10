# frozen_string_literal: true

class Api::V1::ReformMitsumorisController < Api::V1::ApplicationController
  MEDIA_NAME = 'リフォーム比較プロ'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"addr": "東京都港区お台場1-2-3", "name": "山田太郎", "tel": "09012345678" }}' "http://localhost:8000/api/v1/reform_mitsumori"
    data = Soukyakukanri.new(
      media_name: MEDIA_NAME,
      addr: reform_mitsumori_params[:prefecture], 
      name: reform_mitsumori_params[:name],
      tel: reform_mitsumori_params[:tel],
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": {"record_id": "245444", "cemetery_name": "本能寺" }}' "http://localhost:8000/api/v1/reform_mitsumori"
    # ページ遷移するごとにキー名が変わっていきます、cemetery_name, cemetery_addr, work_date, ['addr','area'], 'mitsumori', 'email'
    data = Soukyakukanri.find(reform_mitsumori_params[:record_id])
    data.update(update_params(data))
    render json: { status: :ok, record_id: data.record_id }
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def reform_mitsumori_params
    params.require(:data).permit(:record_id, :pref, :city, :cho, :addr, :name, :tel)
  end

  def update_params(data)
    # {
    #   cemetery_name: reform_mitsumori_params[:cemetery_name] || data.cemetery_name,
    #   cemetery_addr: reform_mitsumori_params[:cemetery_addr] || data.cemetery_addr,
    #   contact_time: reform_mitsumori_params[:addr] || data.contact_time,
    #   contact_note: reform_mitsumori_params[:area] || data.contact_note,
    #   customer_request: reform_mitsumori_params[:mitsumori] || data.customer_request,
    #   email: reform_mitsumori_params[:email] || data.email
    # }
  end
end
