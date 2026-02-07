# == Schema Information
#
# Table name: games
#
#  id              :bigint           not null, primary key
#  cover_image_url :string
#  description     :text
#  developers      :string           default([]), is an Array
#  platforms       :string           default([]), is an Array
#  release_date    :date
#  slug            :string           not null
#  source          :string           default("igdb"), not null
#  title           :string           not null
#  user_rating     :decimal(4, 2)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  igdb_id         :bigint
#
# Indexes
#
#  index_games_on_igdb_id             (igdb_id)
#  index_games_on_platforms           (platforms) USING gin
#  index_games_on_slug                (slug) UNIQUE
#  index_games_on_source_and_igdb_id  (source,igdb_id) UNIQUE
#
class Game < ApplicationRecord
  has_many :game_genres, dependent: :destroy
  has_many :genres, through: :game_genres

  validates :title, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :source, presence: true
  validates :igdb_id, uniqueness: { scope: :source }, allow_nil: true
  validates :user_rating, numericality: { in: 0..100 }, allow_nil: true

  scope :from_igdb, -> { where(source: "igdb") }
  scope :top_rated, -> { where.not(user_rating: nil).order(user_rating: :desc) }
end
