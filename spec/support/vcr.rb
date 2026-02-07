require "vcr"

VCR.configure do |config|
  config.cassette_library_dir = "spec/cassettes"
  config.hook_into :webmock
  config.configure_rspec_metadata!

  config.filter_sensitive_data("<IGDB_CLIENT_ID>") do
    Rails.application.credentials.dig(:igdb, :client_id)
  end

  config.filter_sensitive_data("<IGDB_CLIENT_SECRET>") do
    Rails.application.credentials.dig(:igdb, :client_secret)
  end

  config.filter_sensitive_data("<IGDB_ACCESS_TOKEN>") do |interaction|
    if interaction.response.body.include?("access_token")
      JSON.parse(interaction.response.body)["access_token"] rescue nil
    end
  end

  config.before_record do |interaction|
    interaction.request.headers["Authorization"]&.map! do |value|
      value.gsub(/Bearer .+/, "Bearer <IGDB_ACCESS_TOKEN>")
    end
  end

  config.default_cassette_options = {
    record: :new_episodes,
    match_requests_on: %i[method uri body]
  }
end
