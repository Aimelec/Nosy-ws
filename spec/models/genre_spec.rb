require "rails_helper"

RSpec.describe Genre do
  describe "validations" do
    subject { build(:genre) }

    it { is_expected.to be_valid }

    it "requires a name" do
      subject.name = nil
      expect(subject).not_to be_valid
    end

    it "requires a slug" do
      subject.slug = nil
      expect(subject).not_to be_valid
    end

    it "requires a unique slug" do
      create(:genre, slug: "rpg")
      subject.slug = "rpg"
      expect(subject).not_to be_valid
    end
  end

  describe "associations" do
    it "has many games through game_genres" do
      genre = create(:genre)
      game = create(:game)
      genre.games << game

      expect(genre.games).to include(game)
    end
  end

  describe ".find_or_create_from_slug" do
    it "creates a new genre when slug does not exist" do
      expect {
        Genre.find_or_create_from_slug(name: "RPG", slug: "rpg")
      }.to change(Genre, :count).by(1)
    end

    it "returns existing genre when slug already exists" do
      existing = Genre.find_or_create_from_slug(name: "RPG", slug: "rpg")

      result = Genre.find_or_create_from_slug(name: "RPG", slug: "rpg")
      expect(result).to eq(existing)
      expect(Genre.count).to eq(1)
    end
  end
end
