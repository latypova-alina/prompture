require "aws-sdk-s3"

module S3
  class ObjectKeysFetcher
    include Memery

    def initialize(prefix:)
      @prefix = prefix
    end

    def object_keys
      response.contents.map(&:key)
    end

    private

    attr_reader :prefix

    memoize def s3_client
      Aws::S3::Client.new(region: aws_region)
    end

    def bucket_name
      ENV.fetch("INTERNAL_BUCKET_NAME")
    end

    def aws_region
      ENV.fetch("AWS_REGION")
    end

    memoize def response
      # Assumes fewer than 1000 objects under the prefix (single page).

      s3_client.list_objects_v2(bucket: bucket_name, prefix:)
    end
  end
end
