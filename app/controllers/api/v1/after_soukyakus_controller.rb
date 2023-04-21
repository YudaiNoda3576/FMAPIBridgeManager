# frozen_string_literal: true

class Api::V1::AfterSoukyakusController < Api::V1::ApplicationController
  def update
    # curl -X PATCH -H 'Content-Type: application/json' -d '{"data": { "record_id": 245573, "open_introduction": "業者A,業者B,業者C"}}' "http://localhost:8000/api/v1/after_soukyaku"
    # ページによって
    data = AfterSoukyaku.find(after_soukyaku_params[:record_id])
    data.update(add_contractor(data))
    render json: { status: :ok, record_id: data.record_id }
  rescue StandardError => e
    Rails.logger.error e
    render json: { status: 500, error: "Failure: #{e}" }
  end

  private

  def after_soukyaku_params
    params.require(:data).permit(:record_id, :open_introduction, :invitation, :participation, :nonparticipation)
  end

  # 改行を入れて元のデータと結合する
  def add_contractor(data)
    {
      open_introduction: "#{data.open_introduction}\n#{after_soukyaku_params[:open_introduction]&.gsub(',', "\n")}" || data.open_introduction,
      invitation: "#{data.invitation}\n#{after_soukyaku_params[:invitation]&.gsub(',', "\n")}" || data.invitatione,
      participation: "#{data.participation}\n#{after_soukyaku_params[:participation]&.gsub(',', "\n")}" || data.participation,
      nonparticipation: "#{data.nonparticipation}\n#{after_soukyaku_params[:nonparticipation]&.gsub(',', "\n")}" || data.nonparticipation
    }
  end
end
