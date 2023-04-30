# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::BosekiSoubas', type: :request do
  describe '#create' do
    let(:params) do
      {
        data: {
          cf_ctype: '新たにお墓を建てたい',
          cf_gyard: 'わかりません',
          cf_name: '名前',
          cf_phone: '0120123456',
          cf_pref: '東京',
          cf_address: '新宿区',
          cf_email: 'test.mail',
          cf_misc: '100万円'
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
        post(api_v1_boseki_souba_path, params:)
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
        post(api_v1_boseki_souba_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['status']).to eq 500
      end
    end
  end
end
