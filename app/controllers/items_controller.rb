class ItemsController < ApplicationController
  before_action :new_item, only: [:new, :create]
  before_action :select_item, only: [:show, :edit, :update, :destroy]
  before_action :search_item, only: [:index, :show, :name_search]
  before_action :select_tag_images, only: [:edit, :update]
  before_action :authenticate_user!, only: [:new, :create, :edit, :update, :destroy]

  def index
    @items = Item.order(created_at: :desc).limit(4)
  end

  def create  
    @item_tag = TagForm.new(item_params)

    if @item_tag.valid?
      @item_tag.save
      return redirect_to root_path
    end

    render 'new'
  end

  def show
    @comment = Comment.new()
    @comments = @item.comments
  end

  def edit
    return redirect_to root_path if current_user.id != @item.user.id
  end

  def update
    @item_tag = TagForm.new(update_params)
    
    if @item_tag.valid?
      @item_tag.update
      return redirect_to root_path
    end

    render 'edit'
  end

  def destroy
    @item.destroy if current_user.id == @item.user.id
    redirect_to root_path
  end

  def tag_search
    return nil if params[:input] == ""
    tag = Tag.where(['tag_name LIKE ?', "%#{params[:input]}%"] )
    render json:{ keyword: tag }
  end

  def name_search
    @result = @i.result
  end

  private

  def item_params
    params.require(:item).permit(
      :name,
      :info,
      :category_id,
      :sales_status_id,
      :shipping_fee_status_id,
      :prefecture_id,
      :scheduled_delivery_id,
      :price,
      :tag_name,
      images: []
    ).merge(user_id: current_user.id)
  end

  def update_params
    params.require(:item).permit(
      :name,
      :info,
      :category_id,
      :sales_status_id,
      :shipping_fee_status_id,
      :prefecture_id,
      :scheduled_delivery_id,
      :price,
      :tag_name,
      images: []
    ).merge(user_id: current_user.id ,item_id: params[:id])
  end

  def new_item
    @item = Item.new
  end

  def select_item
    @item = Item.find(params[:id])
  end

  def search_item
    @i = Item.ransack(params[:q])
  end

  def select_tag_images
    @tag = @item.tags
    @item_images = @item.images  
  end
end
