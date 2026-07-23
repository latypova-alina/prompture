module ScriptGenerator
  module ForBloomy
    class EnqueueNextChainedScene
      include Memery

      def self.call(...)
        new(...).call
      end

      def initialize(image_url:, button_request:)
        @image_url = image_url
        @button_request = button_request
      end

      def call
        return unless chained_scenes.can_start_next_scene?

        ScriptGenerator::ProcessScene::ForEditImage.new(
          chat_id:,
          category:,
          reference_image_url: image_url
        ).call(image_prompt_record: next_scene.image_prompt)
      end

      private

      attr_reader :image_url, :button_request

      delegate :command_request, to: :button_request
      delegate :chat_id, :category, to: :command_request
      delegate :next_scene, to: :chained_scenes

      memoize def chained_scenes
        ChainedScenes::Facade.new(button_request:)
      end
    end
  end
end
