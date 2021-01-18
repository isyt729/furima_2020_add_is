class CardsController < ApplicationController
  before_action :set_key, only: [:index, :create]

  def index
    if r_card = Card.find_by(user_id: current_user.id)
      customer = Payjp::Customer.retrieve(r_card.customer_token) # 先程のカード情報を元に、顧客情報を取得
      @regist_card = customer.cards.first
    end

    @card = Card.new
  end

  def create
    customer = Payjp::Customer.create(
      description: 'test', # テストカードであることを説明
      card: params[:token] # 登録しようとしているカード情報
    )

    card = Card.new(
      card_token: params[:token], 
      customer_token: customer.id, 
      user_id: current_user.id
    )

    if card.save
      redirect_to root_path
    else
      render "index"
    end
  end

  def destroy
    regist_card = Card.find_by(user_id: current_user.id)
    regist_card.destroy
    redirect_to cards_path
  end

  private

  def set_key
    Payjp.api_key = ENV['PAYJP_SECRET_KEY']
  end
end
