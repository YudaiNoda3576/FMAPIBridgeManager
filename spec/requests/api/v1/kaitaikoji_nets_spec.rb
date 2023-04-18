# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::BosekiInfos', type: :request do
  describe '#create' do
    let(:params) do
      {
        data: {
          building_type: 'アパート',
          floor: '3',
          area: '20',
          addr: '東京都板橋区1-11-1', name: '織田信長',
          tel: '0120123456',
          email: 'hogehoge@hoge.com',
          mitsumori: 'aaaaa'
        }
      }
    end

    context 'FMのレコード作成成功時' do
      let(:fm_response) { { recordId: '147' } }
      before do
        data = instance_double(Soukyakukanri)
        allow(Soukyakukanri).to receive(:new).and_return(data)
        allow(data).to receive(:save).and_return(true)
        allow(data).to receive(:record_id).and_return(fm_response[:recordId])
      end
      it 'FMのレコードIDを返す' do
        post(api_v1_kaitaikoji_net_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['record_id']).to eq fm_response[:recordId]
      end
    end

    context 'FMのレコード作成失敗時' do
      before do
        data = instance_double(Soukyakukanri)
        allow(Soukyakukanri).to receive(:new).and_return(data)
        allow(data).to receive(:save).and_raise(StandardError)
      end
      it 'status: 500 を返す (レコードIDは含まれない)' do
        post(api_v1_kaitaikoji_net_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['status']).to eq 500
      end
    end
  end
end
