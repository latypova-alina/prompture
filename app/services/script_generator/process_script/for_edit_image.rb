module ScriptGenerator
  module ProcessScript
    class ForEditImage
      include Memery

      def self.call(...)
        new(...).call(...)
      end

      def initialize(chat_id:, category: nil)
        @chat_id = chat_id
        @category = category
      end

      def call(script:)
        command_request = create_command_request!(script:)

        create_reference_image!(command_request:)

        StartEditImageGeneration.call(command_request:)
      end

      private

      attr_reader :chat_id, :category

      def create_command_request!(script:)
        CommandEditImageRequest.create!(chat_id:, user:, category:, prompt: script)
      end

      def create_reference_image!(command_request:)
        UserImageUrlMessage.create!(
          image_url: CartoonCharacter::ReferenceImageUrl.call,
          parent_request: command_request,
          command_request:
        )
      end

      memoize def user
        User.find_by!(chat_id:)
      end
    end
  end
end
