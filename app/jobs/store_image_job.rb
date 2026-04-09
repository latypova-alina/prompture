class StoreImageJob < ApplicationJob
  include Memery

  def perform(record_type, record_id)
    @record_type = record_type
    @record_id = record_id

    upload_image
    update_stored_image
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
end
