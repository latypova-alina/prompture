VCR.configure do |config|
  config.hook_into :webmock
  config.cassette_library_dir = "spec/vcr_cassettes"
  config.hook_into :faraday
  config.configure_rspec_metadata!
  config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = {
    match_requests_on: %i[method uri body],
    erb: true
  }
end
