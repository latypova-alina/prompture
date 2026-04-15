module StoreImage
  class Job < ApplicationJob
    include Memery

    def perform(record_type, record_id)
      @record_type = record_type
      @record_id = record_id

      upload_image
      update_stored_image
      enqueue_success_notification
    rescue ImageResolutionError
      enqueue_error_notification
    end

    private

    attr_reader :record_type, :record_id

    delegate :bytes, :filename, to: :source_image_resolver
    delegate :stored_url, :upload_image, to: :internal_bucket_uploader

    memoize def source_record
      record_type.constantize.find(record_id)
    end

    memoize def source_image_resolver
      StoreImage::Download::Facade.new(source_record)
    end

    memoize def internal_bucket_uploader
      StoreImage::Upload::Facade.new(bytes:, filename:)
    end

    def update_stored_image
      StoreImage::StoredImageUpdater.call(record: source_record, image_url: stored_url)
    end

    def enqueue_success_notification
      StoreImage::SuccessNotifierJob.perform_async(record_type, record_id)
    end

    def enqueue_error_notification
      StoreImage::ErrorNotifierJob.perform_async(record_type, record_id, "ImageResolutionError")
    end
  end
end
