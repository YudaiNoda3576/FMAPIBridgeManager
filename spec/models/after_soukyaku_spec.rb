# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AfterSoukyaku, type: :model do
  describe '#updated_fields' do
    context '元からデータが入っている時' do
      let(:original_data) { '元から入っている店' }
      let(:new_data) { '新しく追加する店' }
      let(:array) { '店1,店2,店3' }

      let(:data) { build(:after_soukyaku) }

      it '改行を挟んで追加される' do
        expect(data.send(:updated_field, original_data, new_data)).to eq "#{original_data}\n#{new_data}"
      end

      it 'カンマ区切りは改行に変換される' do
        expect(data.send(:updated_field, original_data, array)).to eq "#{original_data}\n店1\n店2\n店3"
      end
    end

    context '元からデータが入っていない時' do
      let(:original_data) { nil }
      let(:new_data) { '新しく追加する店' }

      let(:data) { build(:after_soukyaku) }

      it '追加される' do
        expect(data.send(:updated_field, original_data, new_data)).to eq new_data.to_s
      end
    end
  end
end
