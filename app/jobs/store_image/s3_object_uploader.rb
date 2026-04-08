require "securerandom"
require "aws-sdk-s3"

module StoreImage
  class S3ObjectUploader
    include Memery

    def initialize(bytes:, object_key:, content_type:)
      @bytes = bytes
      @object_key = object_key
      @content_type = content_type
    end

    def upload
      raise ArgumentError, "Image bytes are missing" if bytes.blank?

      s3_client.put_object(
        bucket: bucket_name,
        key: object_key,
        body: bytes,
        content_type:
      )
    end

    private

    attr_reader :bytes, :object_key, :content_type

    memoize def s3_client
      Aws::S3::Client.new(region: aws_region)
    end

    def bucket_name
      ENV.fetch("INTERNAL_BUCKET_NAME")
    end

    def aws_region
      ENV.fetch("AWS_REGION")
    end

  end
end
