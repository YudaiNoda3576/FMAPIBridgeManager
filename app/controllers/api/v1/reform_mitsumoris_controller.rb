# frozen_string_literal: true

class Api::V1::ReformMitsumorisController < Api::V1::ApplicationController
  MEDIA_NAME = 'リフォーム比較プロ'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"addr": "東京都港区お台場1-2-3", "name": "山田太郎", "tel": "09012345678" }}' "http://localhost:8000/api/v1/reform_mitsumori"
    data = Soukyakukanri.new(
      media_name: MEDIA_NAME,
      addr: reform_mitsumori_params[:prefecture],
      name: reform_mitsumori_params[:name],
      tel: reform_mitsumori_params[:tel]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": {"record_id": "245551", "budget": "30万円以内" }}' "http://localhost:8000/api/v1/reform_mitsumori"
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": {"record_id": "245551", "point": ["トイレ","台所"] }}' "http://localhost:8000/api/v1/reform_mitsumori"
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": {"record_id": "245551", "contact_time": ["午前","午後"] ,"contact_remark": "テスト" }}' "http://localhost:8000/api/v1/reform_mitsumori"
    # ページ遷移するごとにキー名が変わっていきます(7ステップ)、budget, building_type, point[], building_age, [contact_time[]　, contact_remark], email, mitsumori
    data = Soukyakukanri.find(reform_mitsumori_params[:record_id])
    data.update(update_params(data))
    render json: { status: :ok, record_id: data.record_id }
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def reform_mitsumori_params
    params.require(:data).permit(:record_id, :pref, :city, :cho, :addr, :name, :tel, :building_type, :contact_remark, :budget, :building_age, :email, :mitsumori, point: [], contact_time: [])
  end

  def update_params(data)
    {
      budget: reform_mitsumori_params[:budget] || data.budget,
      building_type: reform_mitsumori_params[:building_type] || data.building_type,
      construction_type: convert_array_to_string(reform_mitsumori_params[:point])|| data.construction_type,
      building_age: reform_mitsumori_params[:building_age] || data.building_age,
      contact_time: convert_array_to_string(reform_mitsumori_params[:contact_time])|| data.contact_time,
      contact_note: reform_mitsumori_params[:contact_remark] || data.contact_note,
      email: reform_mitsumori_params[:email] || data.email,
      customer_request: reform_mitsumori_params[:mitsumori] || data.customer_request
    }
  end

  def convert_array_to_string(array)
    return  nil if array.nil?
    array.join(',')
  end
end