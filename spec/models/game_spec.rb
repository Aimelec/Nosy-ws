require "rails_helper"

RSpec.describe Game do
  describe "validations" do
    subject { build(:game) }

    it { is_expected.to be_valid }

    it "requires a title" do
      subject.title = nil
      expect(subject).not_to be_valid
    end

    it "requires a slug" do
      subject.slug = nil
      expect(subject).not_to be_valid
    end

    it "requires a unique slug" do
      create(:game, slug: "zelda")
      subject.slug = "zelda"
      expect(subject).not_to be_valid
    end

    it "requires a source" do
      subject.source = nil
      expect(subject).not_to be_valid
    end

    it "enforces unique igdb_id per source" do
      existing = create(:game)
      subject.igdb_id = existing.igdb_id
      subject.source = existing.source
      expect(subject).not_to be_valid
    end

    it "allows same igdb_id for different sources" do
      existing = create(:game)
      subject.igdb_id = existing.igdb_id
      subject.source = "rawg"
      expect(subject).to be_valid
    end

    it "allows nil igdb_id" do
      subject.igdb_id = nil
      expect(subject).to be_valid
    end

    it "rejects user_rating below 0" do
      subject.user_rating = -1
      expect(subject).not_to be_valid
    end

    it "rejects user_rating above 100" do
      subject.user_rating = 101
      expect(subject).not_to be_valid
    end

    it "allows nil user_rating" do
      subject.user_rating = nil
      expect(subject).to be_valid
    end
  end

  describe "associations" do
    it "has many genres through game_genres" do
      game = create(:game)
      genre = create(:genre)
      game.genres << genre

      expect(game.genres).to include(genre)
    end

    it "destroys game_genres when destroyed" do
      game = create(:game)
      genre = create(:genre)
      game.genres << genre

      expect { game.destroy }.to change(GameGenre, :count).by(-1)
    end
  end

  describe "scopes" do
    it ".from_igdb returns only igdb-sourced games" do
      igdb_game = create(:game, source: "igdb")
      create(:game, source: "rawg")

      expect(Game.from_igdb).to contain_exactly(igdb_game)
    end

    it ".top_rated returns games ordered by rating descending" do
      low = create(:game, user_rating: 50)
      high = create(:game, user_rating: 95)
      create(:game, user_rating: nil)

      results = Game.top_rated.to_a
      expect(results).to eq([high, low])
    end
  end
end
