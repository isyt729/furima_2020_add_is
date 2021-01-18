FactoryBot.define do
  factory :card do
    card_token {"card_token"}
    customer_token {"customer_token"}
    association :user
  end
end