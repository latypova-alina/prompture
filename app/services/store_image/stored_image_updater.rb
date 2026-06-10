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
      stored_image.update!(image_url:, image_prompt:)
    end

    private

    attr_reader :record, :image_url

    def image_prompt
      ImagePromptResolver.call(record:)
    end

    memoize def stored_image
      record.stored_image || record.build_stored_image
    end
  end
end
