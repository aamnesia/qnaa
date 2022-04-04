FactoryBot.define do
  sequence :title do |n|
    "question_title#{n}"
  end

  factory :question do
    title
    body { "MyText" }
    user

    trait :invalid do
      title { nil }
    end
  end
end
