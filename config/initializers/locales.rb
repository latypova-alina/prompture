config = Rails.application.config_for(:locales_config)
Rails.application.config.x.supported_locales =
  config["supported_locales"].freeze
