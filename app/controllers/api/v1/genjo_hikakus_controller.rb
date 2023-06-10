# frozen_string_literal: true

class Api::V1::GenjoHikakusController < Api::V1::ApplicationController
  # TODO: メディア名をメディア計算式の値に合わせる
  MEDIA_NAME = '原状'

  def create
    # curl -X POST -H 'Content-Type: application/json' -d '{"data": {"building_type": "店舗", "addr": "栃木県宇都宮市1-1-1", "area": "30", "mitsumori": "要望", "name": "名前", "kana": "namae", "tel": "0120123456", "mobile": "09012345678", "email": "fugahoge@yahoo.hoge"}}' "http://localhost:8000/api/v1/genjo_hikaku"
    data = SaftaSoukyakukanri.new(
      media_name: MEDIA_NAME,
      building_type: genjo_hikaku_params[:building_type],
      prefecture: genjo_hikaku_params[:addr],
      area: genjo_hikaku_params[:area],
      customer_request: genjo_hikaku_params[:mitsumori],
      name: genjo_hikaku_params[:name],
      kana: genjo_hikaku_params[:kana],
      tel1: genjo_hikaku_params[:tel],
      tel2: genjo_hikaku_params[:mobile],
      email: genjo_hikaku_params[:email],
      estimated_date: Time.zone.today.strftime("%m/%y/%Y")
    )
    data.save
    render json: { status: :ok, record_id: data.record_id } # Filemaker の record_id を返す
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def genjo_hikaku_params
    params.require(:data).permit(:record_id, :building_type, :addr, :area, :mitsumori,
                                 :name, :kana, :tel, :mobile, :email)
  end
end
