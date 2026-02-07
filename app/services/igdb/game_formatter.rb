module Igdb
  class GameFormatter
    def self.format(game)
      new(game).format
    end

    def initialize(game)
      @game = game
    end

    def format
      {
        igdb_id: @game["id"],
        name: @game["name"],
        slug: @game["slug"],
        summary: @game["summary"],
        cover_url: build_image_url(@game.dig("cover", "url")),
        genres: extract_genres,
        platforms: @game["platforms"]&.map { |p| p["name"] } || [],
        rating: @game["rating"]&.round(1),
        first_release_date: parse_timestamp(@game["first_release_date"]),
        companies: extract_companies
      }
    end

    private

    def extract_genres
      @game["genres"]&.map { |g| { name: g["name"], slug: g["slug"] } } || []
    end

    def extract_companies
      @game["involved_companies"]&.map { |c| c.dig("company", "name") }&.compact || []
    end

    def build_image_url(url)
      return nil unless url
      url = url.gsub("t_thumb", "t_cover_big")
      url.start_with?("//") ? "https:#{url}" : url
    end

    def parse_timestamp(timestamp)
      timestamp ? Time.at(timestamp).utc : nil
    end
  end
end
