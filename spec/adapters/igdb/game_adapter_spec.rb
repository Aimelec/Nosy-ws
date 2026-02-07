require "rails_helper"

RSpec.describe Igdb::GameAdapter do
  let(:igdb_data) do
    {
      igdb_id: 1025,
      name: "Zelda II: The Adventure of Link",
      slug: "zelda-ii-the-adventure-of-link",
      summary: "A classic NES adventure game",
      cover_url: "https://images.igdb.com/cover_big.jpg",
      rating: 66.123,
      first_release_date: Time.utc(1987, 1, 14),
      genres: [
        { name: "Platform", slug: "platform" },
        { name: "Adventure", slug: "adventure" }
      ],
      platforms: ["NES", "Wii"],
      companies: ["Nintendo"]
    }
  end

  subject(:adapter) { described_class.new(igdb_data) }

  describe "#to_game_attributes" do
    let(:attrs) { adapter.to_game_attributes }

    it "maps igdb_id" do
      expect(attrs[:igdb_id]).to eq(1025)
    end

    it "sets source to igdb" do
      expect(attrs[:source]).to eq("igdb")
    end

    it "maps name to title" do
      expect(attrs[:title]).to eq("Zelda II: The Adventure of Link")
    end

    it "maps slug" do
      expect(attrs[:slug]).to eq("zelda-ii-the-adventure-of-link")
    end

    it "maps summary to description" do
      expect(attrs[:description]).to eq("A classic NES adventure game")
    end

    it "maps cover_url to cover_image_url" do
      expect(attrs[:cover_image_url]).to eq("https://images.igdb.com/cover_big.jpg")
    end

    it "rounds user_rating to 2 decimals" do
      expect(attrs[:user_rating]).to eq(66.12)
    end

    it "converts first_release_date to a Date" do
      expect(attrs[:release_date]).to eq(Date.new(1987, 1, 14))
    end

    it "maps platforms" do
      expect(attrs[:platforms]).to eq(["NES", "Wii"])
    end

    it "maps companies to developers" do
      expect(attrs[:developers]).to eq(["Nintendo"])
    end

    context "with nil optional fields" do
      let(:igdb_data) do
        {
          igdb_id: 999,
          name: "Unknown Game",
          slug: "unknown-game",
          summary: nil,
          cover_url: nil,
          rating: nil,
          first_release_date: nil,
          genres: nil,
          platforms: nil,
          companies: nil
        }
      end

      it "handles nil values gracefully" do
        expect(attrs[:description]).to be_nil
        expect(attrs[:cover_image_url]).to be_nil
        expect(attrs[:user_rating]).to be_nil
        expect(attrs[:release_date]).to be_nil
        expect(attrs[:platforms]).to eq([])
        expect(attrs[:developers]).to eq([])
      end
    end
  end

  describe "#genre_data" do
    it "returns genre hashes" do
      expect(adapter.genre_data).to eq([
        { name: "Platform", slug: "platform" },
        { name: "Adventure", slug: "adventure" }
      ])
    end

    it "returns empty array when genres are nil" do
      adapter = described_class.new({ genres: nil })
      expect(adapter.genre_data).to eq([])
    end
  end
end
