module Igdb
  class GameAdapter
    def self.to_game_attributes(igdb_data)
      new(igdb_data).to_game_attributes
    end

    def initialize(igdb_data)
      @data = igdb_data
    end

    def to_game_attributes
      {
        igdb_id: @data[:igdb_id],
        source: "igdb",
        title: @data[:name],
        slug: @data[:slug],
        description: @data[:summary],
        cover_image_url: @data[:cover_url],
        user_rating: @data[:rating]&.to_f&.round(2),
        release_date: @data[:first_release_date]&.to_date,
        platforms: @data[:platforms] || [],
        developers: @data[:companies] || []
      }
    end

    def genre_data
      @data[:genres] || []
    end
  end
end
