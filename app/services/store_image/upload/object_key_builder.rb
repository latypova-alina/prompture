require "securerandom"

module StoreImage
  module Upload
    class ObjectKeyBuilder
      include Memery

      def initialize(filename:)
        @filename = filename
      end

      memoize def object_key
        "images/#{Time.now.utc.strftime('%Y%m%d')}/#{SecureRandom.uuid}-#{filename}"
      end

      private

      attr_reader :filename
    end
  end
end
