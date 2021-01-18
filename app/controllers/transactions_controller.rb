class TransactionsController < ApplicationController
  before_action :select_item, only: [:index, :create]
  before_action :authenticate_user!, only: [:index]

  def index    
    if current_user.id == select_item.user_id || select_item.item_transaction != nil
      redirect_to root_path
    elsif !current_user.card.present?
      redirect_to cards_path
    end
  end

  def create
    @item_transaction = ItemTransaction.new(item_transaction_params)
    customer_token = current_user.card.customer_token
    
    if @item_transaction.valid?
      pay_item(customer_token)
      @item_transaction.save
      return redirect_to root_path
    end
    
    render 'index' 
  end

  private

  def item_transaction_params
    params.permit(
      :item_id,
    ).merge(user_id: current_user.id)
  end

  def pay_item(customer_token)
    # Payjp.api_key = ENV['PAYJP_SECRET_KEY']   
    Payjp.api_key = Rails.application.credentials.payjp[:PAYJP_SECRET_KEY]
    Payjp::Charge.create(
      amount: @item.price,
      customer: customer_token,
      currency: 'jpy'
    )
  end

  def select_item
    @item = Item.find(params[:item_id])
  end
end
