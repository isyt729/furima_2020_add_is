class TagForm
  include ActiveModel::Model
  attr_accessor :name, :info, :category_id, :sales_status_id, :shipping_fee_status_id, :prefecture_id, :scheduled_delivery_id, :price, :images, :tag_name, :user_id, :item_id

  # 値が入っているか検証
  with_options presence: true do
    validates :images
    validates :name
    validates :info
    validates :price, numericality: { with: /\A[0-9]+\z/ , greater_than: 299, less_than:10000000}
    validates :tag_name
  end

  # 選択関係で「---」のままになっていないか検証
  with_options numericality: { other_than: 0} do
    validates :category_id
    validates :sales_status_id
    validates :shipping_fee_status_id
    validates :prefecture_id
    validates :scheduled_delivery_id
  end

  def save
    item = Item.create(name: name, info: info, category_id: category_id, sales_status_id: sales_status_id, shipping_fee_status_id: shipping_fee_status_id, prefecture_id: prefecture_id, scheduled_delivery_id: scheduled_delivery_id, price: price, user_id: user_id, images: images)
    tag = Tag.find_by(tag_name: tag_name)

    if tag.nil? 
      new_tag = Tag.create(tag_name: tag_name)
      ItemTag.create(item_id: item.id, tag_id: new_tag.id)
    else
      ItemTag.create(item_id: item.id, tag_id: tag.id)
    end
  end

  def update
    item = Item.find(item_id)
    item.update(name: name, info: info, category_id: category_id, sales_status_id: sales_status_id, shipping_fee_status_id: shipping_fee_status_id, prefecture_id: prefecture_id, scheduled_delivery_id: scheduled_delivery_id, price: price, user_id: user_id, images: images)

    tag = Tag.find_by(tag_name: tag_name)
    item_tag = ItemTag.find_by(item_id: item.id)    

    if tag.nil?
      new_tag = Tag.create(tag_name: tag_name)
      item_tag.update(tag_id: new_tag.id)
    else
      item_tag.update(item_id: item_id, tag_id: tag.id)
    end
  end
end