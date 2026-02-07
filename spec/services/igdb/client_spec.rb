require "rails_helper"

RSpec.describe Igdb::Client do
  subject(:client) { described_class.new }

  describe "#search_games", vcr: { cassette_name: "igdb/search_games" } do
    it "returns formatted games matching the query" do
      results = client.search_games("zelda", limit: 3)

      expect(results.length).to be <= 3

      game = results.first
      expect(game).to include(:igdb_id, :name, :slug, :cover_url, :genres)
    end
  end

  describe "#fetch_game", vcr: { cassette_name: "igdb/fetch_game" } do
    it "returns a single game with genres and companies" do
      game = client.fetch_game(1025)

      expect(game[:igdb_id]).to eq(1025)
      expect(game[:name]).to eq("Zelda II: The Adventure of Link")
      expect(game[:genres]).not_to be_empty
      expect(game[:companies]).not_to be_empty
    end
  end

  describe "#popular_games", vcr: { cassette_name: "igdb/popular_games" } do
    it "returns popular games sorted by rating with cover images" do
      results = client.popular_games(limit: 5)

      expect(results.length).to eq(5)

      ratings = results.map { |g| g[:rating] }
      expect(ratings).to eq(ratings.sort.reverse)

      results.each do |game|
        expect(game[:cover_url]).to start_with("https://")
      end
    end
  end
end
