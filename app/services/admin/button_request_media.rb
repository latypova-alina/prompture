module Admin
  # What media a button request produced and consumed, for inline previews and raw/stored links.
  class ButtonRequestMedia
    Item = Struct.new(:label, :kind, :url, keyword_init: true)

    OUTPUT_KINDS = {
      ButtonImageProcessingRequest => :image,
      ButtonVideoProcessingRequest => :video,
      ButtonMergeAudioVideoProcessingRequest => :video,
      ButtonAudioProcessingRequest => :audio
    }.freeze

    RAW_URL_COLUMNS = {
      ButtonImageProcessingRequest => :image_url,
      ButtonVideoProcessingRequest => :video_url,
      ButtonMergeAudioVideoProcessingRequest => :video_url,
      ButtonAudioProcessingRequest => :audio_url
    }.freeze

    INPUT_COLUMNS = {
      ButtonVideoProcessingRequest => { image_url: :image },
      ButtonMergeAudioVideoProcessingRequest => { source_video_url: :video, source_audio_url: :audio }
    }.freeze

    def initialize(button_request)
      @button_request = button_request
    end

    def output
      kind = OUTPUT_KINDS[button_request.class]
      url = button_request.try(:resolved_media_url)
      return if kind.nil? || url.blank?

      Item.new(label: "Result", kind:, url:)
    end

    def inputs
      INPUT_COLUMNS.fetch(button_request.class, {}).filter_map do |column, kind|
        url = button_request.public_send(column)
        Item.new(label: column.to_s.humanize, kind:, url:) if url.present?
      end
    end

    def links
      { "Provider URL" => raw_url, "Stored copy" => stored_url }.compact_blank
    end

    private

    attr_reader :button_request

    def raw_url
      column = RAW_URL_COLUMNS[button_request.class]
      button_request.public_send(column) if column
    end

    def stored_url
      button_request.try(:stored_image)&.image_url || button_request.try(:stored_video)&.video_url
    end
  end
end
