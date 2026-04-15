module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class CreateFileMessage
        include Interactor

        delegate :picture_id, :size_bytes, :command_request, :tg_message_id, to: :context

        def call
          context.file_message = picture_id.nil? ? nil : create_file_message
        end

        private

        def create_file_message
          UserFileMessage.create!(
            file_id: picture_id,
            tg_message_id:,
            size: size_bytes,
            parent_request: command_request,
            command_request:
          )
        end
      end
    end
  end
end
