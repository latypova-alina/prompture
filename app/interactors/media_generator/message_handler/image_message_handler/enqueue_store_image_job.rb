module MediaGenerator
  module MessageHandler
    module ImageMessageHandler
      class EnqueueStoreImageJob
        include Interactor

        delegate :image_url_message, :picture_message, :file_message, to: :context

        def call
          context.image_record = image_record
          return if image_record.nil?

          StoreImageJob.perform_async(image_record.class.name, image_record.id)
        end

        private

        def image_record
          image_url_message || picture_message || file_message
        end
      end
    end
  end
end
