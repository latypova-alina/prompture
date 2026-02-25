module Buttons
  class Base
    def self.build(...)
      new(...).build
    end

    private

    def processor_button(processor)
      credits = cost_for(processor)

      {
        text: I18n.t(
          "telegram_webhooks.message.buttons.#{scope}.#{processor}",
          count: credits
        ),
        callback_data: processor.to_s
      }
    end

    def build_processors_for_media
      processors.map do |processor|
        [
          processor_button(
            processor
          )
        ]
      end
    end

    def cost_for(processor)
      COSTS[type][processor]
    end

    def processors
      COSTS[type].keys
    end

    def scope
      raise NotImplementedError
    end

    def type
      raise NotImplementedError
    end
  end
end
