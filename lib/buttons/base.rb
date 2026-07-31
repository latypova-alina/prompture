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

    def regenerate_button_for(scope, processor)
      {
        text: I18n.t(
          "telegram_webhooks.message.buttons.regenerate",
          count: cost_for(scope, processor),
          locale:
        ),
        callback_data: processor.to_s
      }
    end

    def send_as_separate_message_button
      {
        text: I18n.t("telegram_webhooks.message.buttons.send_as_separate_message", locale:),
        callback_data: ButtonActions::SEND_AS_SEPARATE_MESSAGE
      }
    end

    def cost_for(scope, type)
      COSTS[scope.to_sym][type.to_sym]
    end

    def image_to_video_processors
      COSTS[:generate_video].keys - %i[kling_3_standard_image_to_video]
    end
  end
end
