FactoryBot.define do
  factory :comment do
    body 

    trait :invalid do
      body { nil }
    end
  end
end
