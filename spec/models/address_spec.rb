require 'rails_helper'

RSpec.describe Address, type: :model do
  before do
    @address = FactoryBot.build(:address)
  end
  describe '住所作成' do
    context '内容に問題ない場合' do
      it '全て正常' do
        expect(@address.valid?).to eq true
      end
    end
    context '内容に問題がある場合' do
      it 'postal_code:必須' do
        @address.postal_code = ''
        @address.valid?
        expect(@address.errors.full_messages).to include("郵便番号を入力してください")
      end
      it 'postal_code:フォーマット' do
        @address.postal_code = '1234567'
        @address.valid?
        expect(@address.errors.full_messages).to include("郵便番号を正しく入力してください")
      end
      it 'prefecture:必須' do
        @address.prefecture = nil
        @address.valid?
        expect(@address.errors.full_messages).to include("都道府県を入力してください")
      end
      it 'prefecture:0以外' do
        @address.prefecture = 0
        @address.valid?
        expect(@address.errors.full_messages).to include("都道府県を選択してください")
      end
      it 'city:必須' do
        @address.city = ''
        @address.valid?
        expect(@address.errors.full_messages).to include("市区町村を入力してください")
      end
      it 'addresses:必須' do
        @address.addresses = ''
        @address.valid?
        expect(@address.errors.full_messages).to include("番地を入力してください")
      end
      it 'phone_number:必須' do
        @address.phone_number = ''
        @address.valid?
        expect(@address.errors.full_messages).to include("電話番号を入力してください")
      end
      it 'phone_number:11桁以内' do
        @address.phone_number = '1234567891011'
        @address.valid?
        expect(@address.errors.full_messages).to include("電話番号を11桁以内で入力してください")
      end
    end
  end
end
