module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class CreatePictureMessage
        include Interactor

        delegate :picture_id, :width, :height, :size_bytes, :command_request, :tg_message_id, to: :context

        def call
          context.picture_message = picture_id.nil? ? nil : create_picture_message
        end

        private

        def create_picture_message
          UserPictureMessage.create!(
            picture_id:,
            tg_message_id:,
            size: size_bytes,
            width:,
            height:,
            parent_request: command_request,
            command_request:
          )
        end
      end
    end
  end
end
