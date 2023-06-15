# frozen_string_literal: true

class Api::V1::TenpoDesignsController < Api::V1::ApplicationController
  # TODO: メディア名をメディア計算式の値に合わせる
  MEDIA_NAME = '店舗内装'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"name": "名前 , 会社名", "addr": "住所", "tel": "0120123456",  "mitsumori": "要望"}}' "http://localhost:8000/api/v1/tenpo_design"
    data = SunlifeSoukyakukanri.new(
      media_name: MEDIA_NAME,
      name: tenpo_design_params[:name],
      prefecture: tenpo_design_params[:addr],
      tel1: tenpo_design_params[:tel],
      customer_request: tenpo_design_params[:mitsumori],
      estimated_date: Time.zone.today.strftime("%m/%d/%Y")
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": { "record_id": "176299", "position": "部分改修"}}' "http://localhost:8000/api/v1/tenpo_design"
    # ページ遷移するごとにキー名が変わっていきます、position, situation, building_type, work_date, email
    data = SunlifeSoukyakukanri.find(tenpo_design_params[:record_id])
    data.update(update_params(data))
    render json: { status: :ok, record_id: data.record_id }
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def tenpo_design_params
    params.require(:data).permit(:record_id, :position, :building_type, :addr, :name, :tel, :work_date,
                                 :email, :mitsumori, :situation)
  end

  def update_params(data)
    {
      construction_type: tenpo_design_params[:position] || data.construction_type,
      situation: tenpo_design_params[:situation] || data.situation,
      store_type: tenpo_design_params[:building_type] || data.store_type,
      work_date: tenpo_design_params[:work_date] || data.work_date,
      email: tenpo_design_params[:email] || data.email
    }
  end
end
