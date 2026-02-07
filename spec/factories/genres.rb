FactoryBot.define do
  factory :genre do
    name { "Action" }
    sequence(:slug) { |n| "action-#{n}" }
  end
end
