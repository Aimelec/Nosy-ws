require "net/http"
require "json"

module Igdb
  class Client
    BASE_URL = "https://api.igdb.com/v4"

    GAME_FIELDS = [
      "name", "slug", "summary",
      "cover.url", "cover.image_id",
      "genres.name", "genres.slug",
      "platforms.name",
      "rating",
      "first_release_date",
      "involved_companies.company.name"
    ].join(",")

    def initialize(authenticator: Authenticator.new)
      @authenticator = authenticator
    end

    def search_games(query, limit: 10)
      body = "search \"#{sanitize(query)}\"; fields #{GAME_FIELDS}; limit #{limit};"
      fetch_and_format("/games", body)
    end

    def fetch_game(igdb_id)
      body = "fields #{GAME_FIELDS}; where id = #{igdb_id.to_i};"
      results = fetch_and_format("/games", body)
      results&.first
    end

    def popular_games(limit: 50, offset: 0)
      body = <<~QUERY
        fields #{GAME_FIELDS};
        where rating_count > 100 & cover != null;
        sort rating desc;
        limit #{limit};
        offset #{offset};
      QUERY
      fetch_and_format("/games", body)
    end

    private

    def fetch_and_format(endpoint, body)
      data = request(endpoint, body)
      data.map { |game| GameFormatter.format(game) }
    end

    def request(endpoint, body)
      uri = URI("#{BASE_URL}#{endpoint}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true

      req = Net::HTTP::Post.new(uri)
      req["Client-ID"] = @authenticator.client_id
      req["Authorization"] = "Bearer #{@authenticator.access_token}"
      req.body = body

      response = http.request(req)

      case response.code.to_i
      when 200
        JSON.parse(response.body)
      when 401
        @authenticator.reset!
        raise "IGDB authentication failed. Check your credentials."
      when 429
        raise "IGDB rate limit exceeded. Try again later."
      else
        raise "IGDB API error (#{response.code}): #{response.body}"
      end
    end

    def sanitize(query)
      query.gsub('"', '\\"')
    end
  end
end
