module MediaGenerator
  module MessageHandler
    module EditImageMessageHandler
      class ValidateImageMessageType
        include Interactor

        delegate :picture_id, :image_url, :width, :height, :size_bytes, to: :context

        def call
          validator.validate
        rescue MessageTypeError, ImageUrlInvalid => e
          context.fail!(error: e.class)
        end

        private

        def validator
          ::RecordValidators::CommandRequests::EditImageSource.new(
            context: validation_context
          )
        end

        def validation_context
          ImageMessageHandler::ValidationContext.new(
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
