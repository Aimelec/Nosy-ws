require "net/http"
require "json"

module Igdb
  class Authenticator
    AUTH_URL = "https://id.twitch.tv/oauth2/token"

    def access_token
      @access_token ||= fetch_access_token
    end

    def reset!
      @access_token = nil
    end

    def client_id
      credentials[:client_id]
    end

    private

    def fetch_access_token
      uri = URI(AUTH_URL)
      uri.query = URI.encode_www_form(
        client_id: credentials[:client_id],
        client_secret: credentials[:client_secret],
        grant_type: "client_credentials"
      )

      response = Net::HTTP.post(uri, "")
      data = JSON.parse(response.body)

      data["access_token"] || raise("Failed to get IGDB access token: #{data}")
    end

    def credentials
      @credentials ||= Rails.application.credentials.igdb
    end
  end
end
