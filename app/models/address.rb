class Address < ApplicationRecord
  # <<アソシエーション>>
  belongs_to :user, optional: true

  # <<バリデーション>>
  with_options presence: true do
    validates :postal_code, format: { with: /\A\d{3}[-]\d{4}\z/, message: 'を正しく入力してください' }
    validates :prefecture, numericality: { other_than: 0, message: 'を選択してください' }
    validates :city
    validates :addresses
    validates :phone_number, length: { maximum: 11, message: 'を11桁以内で入力してください'}
  end
end
