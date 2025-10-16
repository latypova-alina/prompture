class GeminiImageProcessor
  def initialize(prompt)
    @prompt = prompt
  end

  def image_url
    result = BuildGeminiImage::BuildGeminiImage.call(prompt:)

    return nil if result.failure?

    result.image_url.last
  end

  private

  attr_reader :prompt
end
