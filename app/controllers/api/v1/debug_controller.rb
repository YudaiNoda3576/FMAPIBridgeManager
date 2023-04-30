#  TODO: Remove this controller before production
class Api::V1::DebugController < Api::V1::ApplicationController

  # メディア名で分岐してそれぞれのRecordの全件を返す 　
  def records_by_media_name
    return params[:media_name] if params[:media_name].blank?

    records = {}
    case params[:media_name]
    when 'Safta'
      records = Soukyakukanri.all
    when 'Sunlife'
      records = SunlifeSoukyakukanri.all
    else
      records = {}
    end
    render json: { status: :ok, records: records }
  end
end
