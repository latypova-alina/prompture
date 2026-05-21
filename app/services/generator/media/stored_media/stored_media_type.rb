module Generator
  module Media
    module StoredMedia
      class StoredMediaType
        include Memery

        def initialize(processor:, media_url:, button_request_id:)
          @processor = processor
          @media_url = media_url
          @button_request_id = button_request_id
        end

        def needs_to_be_stored?
          store_policy.needs_to_be_stored?
        end

        def uploader
          uploader_class.new(media_url:, record: media_request)
        end

        private

        attr_reader :processor, :media_url, :button_request_id

        delegate :command_request, to: :media_request
        delegate :media_request, to: :media_request_resolver
        delegate :uploader_class, to: :uploader_resolver

        memoize def store_policy
          StorePolicy.new(processor:, command_request:)
        end

        memoize def media_request_resolver
          MediaRequestResolver.new(processor:, button_request_id:)
        end

        memoize def uploader_resolver
          UploaderResolver.new(processor:)
        end
      end
    end
  end
end
