require "securerandom"

module StoreImage
  module Upload
    class ObjectKeyBuilder
      include Memery

      DEFAULT_FOLDER = "images".freeze

      def initialize(filename:, folder: DEFAULT_FOLDER)
        @filename = filename
        @folder = folder
      end

      memoize def object_key
        "#{folder}/#{Time.now.utc.strftime('%Y%m%d')}/#{SecureRandom.uuid}-#{filename}"
      end

      private

      attr_reader :filename, :folder
    end
  end
end
