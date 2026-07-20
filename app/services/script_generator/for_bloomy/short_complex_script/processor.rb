module ScriptGenerator
  module ForBloomy
    module ShortComplexScript
      class Processor
        include Memery

        def self.call(...)
          new(...).call
        end

        def initialize(chat_id:)
          @chat_id = chat_id
        end

        def call
          Generator.call(
            chat_id:,
            scenes:,
            reference_image_url:
          )
        end

        private

        attr_reader :chat_id

        delegate :scenes, :reference_image_url, to: :context

        memoize def context
          Context.new
        end
      end
    end
  end
end
