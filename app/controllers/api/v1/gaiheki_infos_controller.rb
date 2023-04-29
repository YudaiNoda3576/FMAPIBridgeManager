# frozen_string_literal: true

class Api::V1::GaihekiInfosController < Api::V1::ApplicationController
  MEDIA_NAME = '外壁塗装セレクトナビ'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"addr": "青森県弘前市", "name": "名前", "tel": "0120123456", "chat": "LINE（ライン）"}}' "http://localhost:8000/api/v1/gaiheki_info"
    data = Soukyakukanri.new(
      media_name: MEDIA_NAME,
      prefecture: gaiheki_info_params[:addr],
      name: gaiheki_info_params[:name],
      tel1: gaiheki_info_params[:tel],
      chat: gaiheki_info_params[:chat]
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": {"record_id": "245478", "addr": "本町1-2-3" }}' "http://localhost:8000/api/v1/gaiheki_info"
    # ページ遷移するごとにキー名が変わっていきます、addr, building_type, position,  work_date, [company, area], email
    data = Soukyakukanri.find(gaiheki_info_params[:record_id])
    data.update(update_params(data))
    render json: { status: :ok, record_id: data.record_id }
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def gaiheki_info_params
    params.require(:data).permit(:record_id, :addr, :name, :tel, :chat, :building_type, :position, :work_date, :company,
                                 :area, :email)
  end

  # rubocop:disable Metrics/AbcSize, Metrics/CyclomaticComplexity
  def update_params(data)
    {
      prefecture: "#{data.prefecture}#{gaiheki_info_params[:addr]}" || data.prefecture, # 前画面で入力された市町村と結合
      building_type: gaiheki_info_params[:building_type] || data.building_type,
      construction_type: gaiheki_info_params[:position] || data.construction_type,
      work_date: gaiheki_info_params[:work_date] || data.work_date,
      contact_time: gaiheki_info_params[:company] || data.contact_time,
      contact_note: gaiheki_info_params[:area] || data.contact_note,
      email: gaiheki_info_params[:email] || data.email
    }
  end
  # rubocop:enable Metrics/AbcSize, Metrics/CyclomaticComplexity
end
