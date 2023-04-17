FactoryBot.define do
  factory :merchant do
    sequence(:id)
    name { Faker::Company.name }
    status { Faker::Number.between(from: 0, to: 1) }
    created_at { Time.zone.now }
    updated_at { Time.zone.now }
  end
end
