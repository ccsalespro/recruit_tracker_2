FactoryBot.define do
  factory :recruit do
    sequence(:name) { |n| "recruit #{n}" }
    phone_number "+11234567890"
    sequence(:email) { |n| "recruit#{n}@test.com" }
    description 'test description'
    start_date '2019/02/22'
    closed false
  end
end
