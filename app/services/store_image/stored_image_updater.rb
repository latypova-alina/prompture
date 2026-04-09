module StoreImage
  class StoredImageUpdater
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(record:, image_url:)
      @record = record
      @image_url = image_url
    end

    def call
      stored_image.update!(image_url:)
    end

    private

    attr_reader :record, :image_url

    memoize def stored_image
      record.stored_image || record.build_stored_image
    end
  end
end
