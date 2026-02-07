FactoryBot.define do
  factory :game do
    title { "The Witcher 3" }
    sequence(:slug) { |n| "the-witcher-3-#{n}" }
    source { "igdb" }
    sequence(:igdb_id) { |n| 1000 + n }
    description { "An open world RPG" }
    cover_image_url { "https://images.igdb.com/cover.jpg" }
    user_rating { 92.5 }
    release_date { Date.new(2015, 5, 19) }
    platforms { ["PC (Microsoft Windows)", "PlayStation 4"] }
    developers { ["CD Projekt RED"] }
  end
end
