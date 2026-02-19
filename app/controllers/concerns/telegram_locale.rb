module TelegramLocale
  extend ActiveSupport::Concern

  included { before_action :set_locale }

  def normalized_locale
    return I18n.default_locale unless language_code

    short = language_code.to_s.split("-").first.to_sym

    I18n.available_locales.include?(short) ? short : I18n.default_locale
  end

  private

  def set_locale
    I18n.locale = resolved_locale
  end

  def resolved_locale
    return user.locale if user&.locale.present?

    normalized_locale
  end

  def language_code
    update.dig("message", "from", "language_code") ||
      update.dig("callback_query", "from", "language_code") ||
      update.dig("edited_message", "from", "language_code")
  end
end
