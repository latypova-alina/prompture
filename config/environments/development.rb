require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.cache_classes = false

  config.eager_load = false

  config.consider_all_requests_local = true

  config.server_timing = true

  if Rails.root.join("tmp/caching-dev.txt").exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      "Cache-Control" => "public, max-age=#{2.days.to_i}"
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  config.active_support.deprecation = :log

  config.active_support.disallowed_deprecation = :raise

  config.active_support.disallowed_deprecation_warnings = []

  config.telegram_updates_controller.session_store = :memory_store
  config.host_authorization = { exclude: ->(_request) { true } }

  # "admin.localhost" is only 2 dot-segments, so Rails' default tld_length (1)
  # extracts no subdomain for it (it expects domain+tld to take 2 segments,
  # like caivemanator.com). Lowering it to 0 lets "admin.localhost" resolve
  # to subdomain "admin" for local testing of the admin subdomain routes.
  config.action_dispatch.tld_length = 0
end
