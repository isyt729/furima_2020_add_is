class Card < ApplicationRecord
  # <<アソシエーション>>
  belongs_to :user
  # <<バリデーション>>
  with_options presence: true do
    validates :card_token
    validates :customer_token
  end
end
