class Moderation::OpenaiImageModeration < Moderation::OpenaiModerationBase
  def initialize(bytes:, content_type:)
    super()
    @bytes = bytes
    @content_type = content_type
  end

  private

  attr_reader :bytes, :content_type

  def input
    [{ type: "image_url", image_url: { url: data_uri } }]
  end

  def data_uri
    "data:#{content_type};base64,#{Base64.strict_encode64(bytes)}"
  end
end
