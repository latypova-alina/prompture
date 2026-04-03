module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class ValidateMessageType
        include Interactor

        delegate :picture_id, :image_url, to: :context

        def call
          validator.validate
        rescue MessageTypeError, ImageUrlInvalid => e
          context.fail!(error: e.class)
        end

        private

        def validator
          ::RecordValidators::CommandRequests::ImageToVideo.new(picture_id:, image_url:)
        end
      end
    end
  end
end
