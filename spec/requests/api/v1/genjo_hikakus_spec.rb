# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::GenjoHikakus', type: :request do
  describe '#create' do
    let(:params) do
      {
        data: {
          building_type: '店舗',
          addr: '栃木県宇都宮市1-1-1',
          area: '30',
          mitsumori: '要望',
          name: '名前',
          kana: 'namae',
          tel: '0120123456',
          mobile: '09012345678',
          email: 'fugahoge@yahoo.hoge'
        }
      }
    end

    context 'FMのレコード作成成功時' do
      let(:fm_response) { { recordId: '147' } }
      before do
        data = instance_double(SaftaSoukyakukanri)
        allow(SaftaSoukyakukanri).to receive(:new).and_return(data)
        allow(data).to receive(:save).and_return(true)
        allow(data).to receive(:record_id).and_return(fm_response[:recordId])
      end
      it 'FMのレコードIDを返す' do
        post(api_v1_genjo_hikaku_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['record_id']).to eq fm_response[:recordId]
      end
    end

    context 'FMのレコード作成失敗時' do
      before do
        data = instance_double(SaftaSoukyakukanri)
        allow(SaftaSoukyakukanri).to receive(:new).and_return(data)
        allow(data).to receive(:save).and_raise(StandardError)
      end
      it 'status: 500 を返す (レコードIDは含まれない)' do
        post(api_v1_genjo_hikaku_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['status']).to eq 500
      end
    end
  end
end
