# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::V1::BosuiIkkatsus', type: :request do
  describe '#create' do
    let(:params) do
      {
        data: {
          position: 'ベランダの防水工事',
          building_type: '一戸建て住宅',
          addr: '愛知県名古屋市1-1-1',
          name: '名前',
          tel: '0120123456'
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
        post(api_v1_bosui_ikkatsu_path, params:)
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
        post(api_v1_bosui_ikkatsu_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['status']).to eq 500
      end
    end
  end

  describe '#update' do
    let(:record_id) { 147 }
    let(:params) do
      {
        data: {
          record_id: '245530',
          work_date: 'できるだけ早く'
        }
      }
    end
    let(:data) { build(:sunlife_soukyakukanri) }

    context 'FMのレコード更新成功時' do
      let(:fm_response) { { recordId: record_id } }

      before do
        allow(SunlifeSoukyakukanri).to receive(:find).and_return(data)
        allow(data).to receive(:update).and_return(true)
        allow(data).to receive(:record_id).and_return(fm_response[:recordId])
      end

      it 'FMのレコードIDを返す' do
        patch(api_v1_bosui_ikkatsu_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['record_id']).to eq fm_response[:recordId]
      end
    end

    context 'FMのレコード更新失敗時' do
      before do
        allow(SunlifeSoukyakukanri).to receive(:find).and_raise(StandardError)
      end

      it 'status: 500 を返す (レコードIDは含まれない)' do
        patch(api_v1_bosui_ikkatsu_path, params:)
        expect(response).to have_http_status :ok
        expect(JSON.parse(response.body)['status']).to eq 500
      end
    end
  end
end
