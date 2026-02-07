# == Schema Information
#
# Table name: game_genres
#
#  id         :bigint           not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  game_id    :bigint           not null
#  genre_id   :bigint           not null
#
# Indexes
#
#  index_game_genres_on_game_id               (game_id)
#  index_game_genres_on_game_id_and_genre_id  (game_id,genre_id) UNIQUE
#  index_game_genres_on_genre_id              (genre_id)
#
# Foreign Keys
#
#  fk_rails_...  (game_id => games.id)
#  fk_rails_...  (genre_id => genres.id)
#
class GameGenre < ApplicationRecord
  belongs_to :game
  belongs_to :genre

  validates :game_id, uniqueness: { scope: :genre_id }
end
