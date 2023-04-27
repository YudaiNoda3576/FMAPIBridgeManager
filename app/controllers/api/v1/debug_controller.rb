#  TODO: Remove this controller before production
class Api::V1::DebugController < Api::V1::ApplicationController
  def show_env
    render json: { redis_host: ENV['REDIS_HOST'], redis_port: ENV['REDIS_PORT'], rails_env: ENV['RAILS_ENV'], redis_url: ENV['REDIS_URL'] }
  end

  def all_records
    records = Soukyakukanri.all
    binding.pry
    render json: { status: :ok, records: records }
  end
end
