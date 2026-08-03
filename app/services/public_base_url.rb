module PublicBaseUrl
  def self.resolve
    return ENV["GENERATOR_WEBHOOK_BASE_URL"] unless Rails.env.production?

    ENV["PRODUCTION_BASE_URL"]
  end
end
