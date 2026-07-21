module MediaGenerator
  module FirstLastFrameToVideo
    class AssignImageUrl
      def self.call(image_record:)
        new(image_record:).call
      end

      def initialize(image_record:)
        @image_record = image_record
      end

      def call
        return if image_url.blank?

        assign_image_url
      end

      private

      attr_reader :image_record

      delegate :command_request, to: :image_record
      delegate :start_image_url, :end_image_url, to: :command_request

      def image_url
        image_record.resolved_image_url
      end

      def assign_image_url
        if start_image_url.blank?
          command_request.update!(start_image_url: image_url)
        elsif end_image_url.blank?
          command_request.update!(end_image_url: image_url)
        end
      end
    end
  end
end
