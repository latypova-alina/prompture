require "aws-sdk-s3"

module StoreMedia
  module Upload
    class S3ObjectUploader
      include Memery

      MAX_UPLOAD_ATTEMPTS = 3

      def initialize(bytes:, object_key:, content_type:)
        @bytes = bytes
        @object_key = object_key
        @content_type = content_type
      end

      def upload
        raise ArgumentError, "Media bytes are missing" if bytes.blank?

        with_retries { put_object }
      end

      private

      attr_reader :bytes, :object_key, :content_type

      def put_object
        s3_client.put_object(
          bucket: bucket_name,
          key: object_key,
          body: bytes,
          content_type:
        )
      end

      def with_retries
        attempt = 1

        begin
          yield
        rescue StandardError
          raise if attempt >= MAX_UPLOAD_ATTEMPTS

          attempt += 1
          sleep(attempt)
          retry
        end
      end

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
end
