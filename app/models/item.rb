class Item < ApplicationRecord
  extend ActiveHash::Associations::ActiveRecordExtensions
    # <<アクティブハッシュの設定関連>>
    belongs_to_active_hash :category
    belongs_to_active_hash :sales_status
    belongs_to_active_hash :shipping_fee_status
    belongs_to_active_hash :prefecture
    belongs_to_active_hash :scheduled_delivery

  # <<アクティブストレージの設定関連>>
  has_many_attached :images

  # <<アソシエーション>>
  belongs_to :user
  has_one :item_transaction
  has_many :item_tags
  has_many :tags, through: :item_tags
  has_many :comments

  with_options presence: true do
    validates :images
    validates :name
    validates :info
    validates :price, numericality: { with: /\A[0-9]+\z/ , greater_than: 299, less_than:10000000}
  end

  # 選択関係で「---」のままになっていないか検証
  with_options numericality: { other_than: 0} do
    validates :category_id
    validates :sales_status_id
    validates :shipping_fee_status_id
    validates :prefecture_id
    validates :scheduled_delivery_id
  end

end
