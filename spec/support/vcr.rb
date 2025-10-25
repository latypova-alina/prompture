VCR.configure do |config|
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :faraday, :webmock
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = false
  config.default_cassette_options = {
    match_requests_on: %i[method uri body],
    erb: true
  }
end
