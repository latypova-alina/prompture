module StoreVideo
  class Registrar
    include Memery

    def self.call(...)
      new(...).call
    end

    def initialize(record:, video_url:)
      @record = record
      @video_url = video_url
    end

    def call
      return unless registerable?

      stored_video.update!(stored_video_attributes)
    end

    private

    attr_reader :record, :video_url

    delegate :command_request, :origin_subcategory, :parent_prompt, to: :record
    delegate :category, to: :command_request

    def registerable?
      ContentCategory.store_video?(category) && origin_subcategory.present?
    end

    memoize def stored_video
      ::StoredVideo.find_or_initialize_by(source: record)
    end

    def stored_video_attributes
      {
        video_url:,
        category:,
        subcategory: origin_subcategory,
        prompt: parent_prompt
      }
    end
  end
end
