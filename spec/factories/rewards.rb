FactoryBot.define do
  factory :reward do
    sequence :title do |n|
      "Reward_#{n}"
    end
    image { fixture_file_upload(Rails.root.join('app', 'assets', 'images', 'ruby_logo.png'), 'ruby_logo.png') }
  end
end
