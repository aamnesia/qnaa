FactoryBot.define do
  factory :link do
    name { "links_name" }
    url { "https://google.com" }

    trait :gist do
      name {'gist_link'}
      url {'https://gist.github.com/aamnesia/3c5a1bd3e61cd6513087082d802eb0ea'}
    end
  end
end
