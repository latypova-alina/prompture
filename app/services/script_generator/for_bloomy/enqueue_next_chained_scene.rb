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
        return unless next_scene_ready?

        ScriptGenerator::ProcessScene::ForEditImage.new(
          chat_id:,
          category:,
          reference_image_url: image_url
        ).call(image_prompt_record: next_scene_image_prompt)
      end

      private

      attr_reader :image_url, :button_request

      delegate :command_request, to: :button_request
      delegate :chat_id, :category, to: :command_request
      delegate :image_prompt, to: :next_scene, prefix: true
      delegate :image_prompt_id, to: :command_request
      delegate :script, to: :scene, allow_nil: true
      delegate :scenes, to: :script, allow_nil: true
      delegate :order, to: :scene, allow_nil: true, prefix: true

      memoize :script

      def next_scene_ready?
        next_scene.present? &&
          next_scene.image_prompt.present? &&
          !next_scene.image_prompt.stored_images.exists?
      end

      memoize def scene
        return if image_prompt_id.blank?

        Scene.find_by(image_prompt_id:)
      end

      memoize def next_scene
        return if script.blank? || !script.chained_references?

        scenes.find_by(order: scene_order + 1)
      end
    end
  end
end
