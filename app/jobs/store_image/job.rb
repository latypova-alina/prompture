module StoreImage
  class Job < ApplicationJob
    include Memery

    def perform(record_type, record_id)
      @record_type = record_type
      @record_id = record_id

      upload
      stored_image.update!(image_url: stored_url)
    end

    private

    attr_reader :record_type, :record_id

    delegate :bytes, :filename, to: :source_image_resolver
    delegate :stored_url, :upload, to: :internal_bucket_uploader

    memoize def source_record
      record_type.constantize.find(record_id)
    end

    memoize def source_image_resolver
      SourceImageResolver.new(source_record)
    end

    memoize def stored_image
      source_record.stored_image || source_record.build_stored_image
    end

    memoize def internal_bucket_uploader
      InternalBucketUploader.new(bytes:, filename:)
    end
  end
end
