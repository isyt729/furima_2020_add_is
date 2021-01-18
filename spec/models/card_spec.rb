require 'rails_helper'

RSpec.describe Card, type: :model do
  before do
    @card = FactoryBot.build(:card)
  end
  describe '商品作成' do
    context '内容に問題ない場合' do
      it '全て正常' do
        expect(@card.valid?).to eq true
      end
    end
    context '内容に問題がある場合' do
      it 'card_token:必須' do
        @card.card_token = nil
        @card.valid?
        expect(@card.errors.full_messages).to include("Card tokenを入力してください")
      end
      it 'customer_token:必須' do
        @card.customer_token = nil
        @card.valid?
        expect(@card.errors.full_messages).to include("Customer tokenを入力してください")
      end
    end
  end
end
