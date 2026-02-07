require "rails_helper"

RSpec.describe GameImporter do
  subject(:importer) { described_class.new(adapter_class: Igdb::GameAdapter) }

  let(:igdb_data) do
    {
      igdb_id: 1025,
      name: "Zelda II: The Adventure of Link",
      slug: "zelda-ii-the-adventure-of-link",
      summary: "A classic NES adventure",
      cover_url: "https://images.igdb.com/cover.jpg",
      rating: 66.1,
      first_release_date: Time.utc(1987, 1, 14),
      genres: [
        { name: "Platform", slug: "platform" },
        { name: "Adventure", slug: "adventure" }
      ],
      platforms: [ "NES" ],
      companies: [ "Nintendo" ]
    }
  end

  describe "#import" do
    it "creates a new game" do
      expect { importer.import(igdb_data) }.to change(Game, :count).by(1)
    end

    it "creates associated genres" do
      importer.import(igdb_data)
      expect(Genre.pluck(:slug)).to match_array([ "platform", "adventure" ])
    end

    it "links genres to the game" do
      game = importer.import(igdb_data)
      expect(game.genres.count).to eq(2)
    end

    it "maps IGDB fields to local attributes" do
      game = importer.import(igdb_data)

      expect(game.title).to eq("Zelda II: The Adventure of Link")
      expect(game.slug).to eq("zelda-ii-the-adventure-of-link")
      expect(game.source).to eq("igdb")
      expect(game.igdb_id).to eq(1025)
      expect(game.developers).to eq([ "Nintendo" ])
    end

    it "updates an existing game on re-import" do
      importer.import(igdb_data)

      updated_data = igdb_data.merge(name: "Zelda II (Updated)")
      game = importer.import(updated_data)

      expect(Game.count).to eq(1)
      expect(game.title).to eq("Zelda II (Updated)")
    end

    it "reuses existing genres on re-import" do
      importer.import(igdb_data)
      importer.import(igdb_data.merge(slug: "zelda-ii-remaster", igdb_id: 9999))

      expect(Genre.where(slug: "platform").count).to eq(1)
    end

    it "raises ImportError for invalid data" do
      invalid_data = igdb_data.merge(name: nil, slug: nil)

      expect { importer.import(invalid_data) }.to raise_error(GameImporter::ImportError)
    end
  end

  describe "#import_batch" do
    let(:second_game) do
      {
        igdb_id: 2000,
        name: "Bloodborne",
        slug: "bloodborne",
        summary: "A souls-like game",
        cover_url: "https://images.igdb.com/bb.jpg",
        rating: 92.0,
        first_release_date: Time.utc(2015, 3, 24),
        genres: [ { name: "Adventure", slug: "adventure" } ],
        platforms: [ "PlayStation 4" ],
        companies: [ "FromSoftware" ]
      }
    end

    it "imports multiple games" do
      results = importer.import_batch([ igdb_data, second_game ])

      expect(results[:success].count).to eq(2)
      expect(results[:failed]).to be_empty
    end

    it "tracks failures without stopping the batch" do
      invalid_data = igdb_data.merge(name: nil, slug: nil)

      results = importer.import_batch([ invalid_data, second_game ])

      expect(results[:success].count).to eq(1)
      expect(results[:failed].count).to eq(1)
      expect(results[:failed].first[:error]).to include("Failed to import game")
    end
  end
end
