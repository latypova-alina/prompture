module Buttons
  class Base
    def initialize(locale: I18n.locale)
      @locale = locale
    end

    def self.build(...)
      new(...).build
    end

    private

    attr_reader :locale

    def button_for(scope, type)
      credits = cost_for(scope, type)

      {
        text: I18n.t(
          "telegram_webhooks.message.buttons.#{scope}.#{type}",
          count: credits,
          locale:
        ),
        callback_data: type.to_s
      }
    end

    def cost_for(scope, type)
      COSTS[scope.to_sym][type.to_sym]
    end
  end
end
