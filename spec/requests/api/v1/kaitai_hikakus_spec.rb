# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::kaitai_hikaku', type: :request do
  describe '#create' do
    let(:params) do
      {
        data: {
          building_type: '一戸建て',
          addr: '北海道札幌市中央区',
          name: '徳川家康',
          tel: '01201234567',
          mitsumori: '要望'
        }
      }
    end

    context 'FMのレコード作成成功時' do
      let(:fm_response) { { recordId: '147' } }
      before do
        data = instance_double(SunlifeSoukyakukanri)
        allow(SunlifeSoukyakukanri).to receive(:new).and_return(data)
        allow(data).to receive(:save).and_return(true)
        allow(data).to receive(:record_id).and_return(fm_response[:recordId])
      end
      it 'FMのレコードIDを返す' do
        post(api_v1_kaitai_hikaku_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['record_id']).to eq fm_response[:recordId]
      end
    end

    context 'FMのレコード作成失敗時' do
      before do
        data = instance_double(SunlifeSoukyakukanri)
        allow(SunlifeSoukyakukanri).to receive(:new).and_return(data)
        allow(data).to receive(:save).and_raise(StandardError)
      end
      it 'status: 500 を返す (レコードIDは含まれない)' do
        post(api_v1_kaitai_hikaku_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['status']).to eq 500
      end
    end
  end
end
