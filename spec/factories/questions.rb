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

    trait :with_attachment do
      files { fixture_file_upload(Rails.root.join('spec', 'rails_helper.rb'), 'rails_helper.rb') }
    end
  end
end
