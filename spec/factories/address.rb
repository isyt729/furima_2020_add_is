FactoryBot.define do
  factory :address do
    postal_code {"111-1111"}
    prefecture {1}
    city { 'シティ' }
    addresses {'アドレス'}
    phone_number {'09012345678'}
    association :user
  end
end