class ApplicationJob
  include Sidekiq::Job

  private

  def with_locale(locale = nil, &block)
    I18n.with_locale(locale.presence || I18n.default_locale, &block)
  end
end
