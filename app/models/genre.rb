# == Schema Information
#
# Table name: genres
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  slug       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
# Indexes
#
#  index_genres_on_slug  (slug) UNIQUE
#
class Genre < ApplicationRecord
  has_many :game_genres, dependent: :destroy
  has_many :games, through: :game_genres

  validates :name, presence: true
  validates :slug, presence: true, uniqueness: true

  def self.find_or_create_from_slug(name:, slug:)
    find_or_create_by!(slug: slug) do |genre|
      genre.name = name
    end
  end
end
