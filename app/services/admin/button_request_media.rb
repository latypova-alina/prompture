module Admin
  # What media a button request produced and consumed, for inline previews and raw/stored links.
  class ButtonRequestMedia
    include Memery

    OUTPUT_KINDS = {
      ButtonImageProcessingRequest => :image,
      ButtonVideoProcessingRequest => :video,
      ButtonMergeAudioVideoProcessingRequest => :video,
      ButtonAudioProcessingRequest => :audio
    }.freeze

    RESULT_URL_COLUMNS = {
      ButtonImageProcessingRequest => :image_url,
      ButtonVideoProcessingRequest => :video_url,
      ButtonMergeAudioVideoProcessingRequest => :video_url,
      ButtonAudioProcessingRequest => :audio_url
    }.freeze

    INPUT_COLUMNS = {
      ButtonVideoProcessingRequest => { image_url: :image },
      ButtonMergeAudioVideoProcessingRequest => { source_video_url: :video, source_audio_url: :audio }
    }.freeze

    INPUT_LABELS = { image: "Input image", video: "Input video", audio: "Input audio" }.freeze

    def initialize(button_request)
      @button_request = button_request
    end

    def output
      kind = OUTPUT_KINDS[button_request.class]
      url = button_request.try(:resolved_media_url)
      return if kind.nil? || url.blank?

      Admin::MediaItem.new(label: "Result", kind:, url:)
    end

    memoize def inputs
      column_inputs + edit_image_inputs
    end

    def links
      { "Result URL" => result_url, "Stored copy" => stored_url }.compact_blank.merge(input_links)
    end

    private

    attr_reader :button_request

    def column_inputs
      INPUT_COLUMNS.fetch(button_request.class, {}).filter_map do |column, kind|
        input_item(kind, button_request.public_send(column))
      end
    end

    # An image edit's source picture lives on its parent message (the same URL sent to fal as image_urls).
    def edit_image_inputs
      return [] unless Generator::Media::Image::CreateTask::PayloadEnhancers::EditImage.applies_to?(button_request)

      [input_item(:image, button_request.parent_request.try(:resolved_image_url))].compact
    end

    def input_item(kind, url)
      Admin::MediaItem.new(label: INPUT_LABELS.fetch(kind), kind:, url:) if url.present?
    end

    def input_links
      inputs.to_h { |item| [item.label, item.url] }
    end

    def result_url
      column = RESULT_URL_COLUMNS[button_request.class]
      button_request.public_send(column) if column
    end

    def stored_url
      button_request.try(:stored_image)&.image_url || button_request.try(:stored_video)&.video_url
    end
  end
end
