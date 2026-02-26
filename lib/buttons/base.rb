module Buttons
  class Base
    def self.build(...)
      new(...).build
    end

    private

    def button_for(scope, type)
      credits = cost_for(scope, type)

      {
        text: I18n.t(
          "telegram_webhooks.message.buttons.#{scope}.#{type}",
          count: credits
        ),
        callback_data: type.to_s
      }
    end

    def cost_for(scope, type)
      COSTS[scope][type]
    end
  end
end
