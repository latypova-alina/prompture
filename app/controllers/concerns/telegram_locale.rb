module TelegramLocale
  extend ActiveSupport::Concern

  included { before_action :set_locale }

  def normalized_locale
    return I18n.default_locale unless language_code

    short = language_code.to_s.split("-").first.to_sym

    locale_supported?(short) ? short : I18n.default_locale
  end

  private

  def set_locale
    I18n.locale = resolved_locale
  end

  def resolved_locale
    return user_locale if user_locale && locale_supported?(user_locale)

    normalized_locale
  end

  def language_code
    update.dig("message", "from", "language_code") ||
      update.dig("callback_query", "from", "language_code") ||
      update.dig("edited_message", "from", "language_code")
  end

  def locale_supported?(locale)
    Rails.application.config.x.supported_locales.include?(locale.to_s)
  end

  def user_locale
    user&.locale.presence&.to_s
  end
end
