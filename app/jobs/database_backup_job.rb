class DatabaseBackupJob < ApplicationJob
  include Memery

  def perform
    uploader.upload
  end

  private

  memoize def uploader
    StoreMedia::Upload::S3ObjectUploader.new(
      bytes: dump_bytes,
      object_key: object_key,
      content_type: "application/octet-stream"
    )
  end

  memoize def dump_bytes
    Backup::PostgresDumper.new.call
  end

  memoize def object_key
    Backup::ObjectKeyBuilder.new.call
  end
end
