module StoreImage
  module ButtonHandler
    class ParseButtonRequest
      include Interactor
      include Memery

      delegate :button_request, to: :context

      def call
        context.record_type = record_type
        context.record_id = record_id
        context.user = user
        context.terms_accepted = true
      end

      private

      def parts
        button_request.split(":")
      end

      def record_type
        parts[1]
      end

      def record_id
        parts[2]
      end

      memoize def image_record
        record_type.constantize.find(record_id)
      end

      def user
        image_record.user
      end
    end
  end
end
