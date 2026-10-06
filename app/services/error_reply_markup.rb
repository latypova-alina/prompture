# Optional reply_markup to attach to an error reply, per error class. Most errors are text-only;
# "not enough stones" gets the Open Store button so the user can top up right away (only while
# the stars payments feature is enabled for them).
class ErrorReplyMarkup
  MARKUPS = {
    "InsufficientCreditsError" => :open_store_markup
  }.freeze

  def self.call(...)
    new(...).call
  end

  def initialize(error:, user:, locale:)
    @error = error
    @user = user
    @locale = locale
  end

  def call
    method_name = MARKUPS[error.class.name]
    send(method_name) if method_name
  end

  private

  attr_reader :error, :user, :locale

  def open_store_markup
    return unless Flipper.enabled?(:flipper_stars_payments, user)

    { inline_keyboard: [[StarsPayment::OpenStoreButton.call(locale:)]] }
  end
end
