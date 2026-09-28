module StoreImage
  module ButtonHandler
    class ResumeNotification
      include Interactor

      delegate :record_type, :record_id, to: :context

      def call
        StoreImage::SuccessNotifierJob.perform_async(record_type, record_id)
      end
    end
  end
end
