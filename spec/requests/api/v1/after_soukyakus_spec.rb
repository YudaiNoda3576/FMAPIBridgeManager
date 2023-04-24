# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::AfterSoukyakus', type: :request do
  describe '#update' do
    let(:record_id) { 147 }
    let(:params) do
      {
        data: {
          open_introduction: 'hoge石材店',
          record_id:
        }
      }
    end
    let(:data) { build(:after_soukyaku) }

    context 'FMのレコード更新成功時' do
      let(:fm_response) { { recordId: record_id } }

      before do
        allow(AfterSoukyaku).to receive(:find).and_return(data)
        allow(data).to receive(:update_contractor_fields).and_return(true)
        allow(data).to receive(:record_id).and_return(fm_response[:recordId])
      end

      it 'FMのレコードIDを返す' do
        patch(api_v1_after_soukyaku_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['record_id']).to eq fm_response[:recordId]
      end
    end

    context 'FMのレコード更新失敗時' do
      before do
        allow(AfterSoukyaku).to receive(:find).and_raise(StandardError)
      end

      it 'status: 500 を返す (レコードIDは含まれない)' do
        patch(api_v1_after_soukyaku_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['status']).to eq 500
      end
    end
  end
end
