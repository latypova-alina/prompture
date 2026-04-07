module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class ValidateMessageType
        include Interactor

        delegate :picture_id, :image_url, :width, :height, :size_bytes, to: :context

        def call
          validator.validate
        rescue MessageTypeError, ImageUrlInvalid => e
          context.fail!(error: e.class)
        end

        private

        def validator
          ::RecordValidators::CommandRequests::ImageToVideo.new(
            context: validation_context
          )
        end

        def validation_context
          ValidationContext.new(
            picture_id:,
            image_url:,
            width:,
            height:,
            size_bytes:
          )
        end
      end
    end
  end
end
