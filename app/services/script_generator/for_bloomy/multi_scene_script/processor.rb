module ScriptGenerator
  module ForCartoon
    module MultiSceneScript
      class Processor
        include Memery

        def self.call(...)
          new(...).call
        end

        def initialize(chat_id:)
          @chat_id = chat_id
        end

        def call
          Processors::ForImagePrompts.call(
            chat_id:,
            scenes: scene_records,
            reference_image_url:
          )
        end

        private

        attr_reader :chat_id

        delegate :scenes, :reference_image_url, to: :context

        memoize def context
          Context.new
        end

        memoize def script
          Script.create!(chained_references: false)
        end

        memoize def scene_records
          scenes.each_with_index.map do |scene_text, index|
            Scene.create!(script:, scene_text:, order: index + 1)
          end
        end
      end
    end
  end
end
