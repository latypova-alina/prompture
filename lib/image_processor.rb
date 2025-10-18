class ImageProcessor
  def initialize(prompt, processor_type)
    @prompt = prompt
    @processor_type = processor_type
  end

  def image_url
    result = BuildImage::BuildImage.call(prompt:, processor_type:)

    return nil if result.failure?

    result.image_url.last
  end

  private

  attr_reader :prompt, :processor_type
end
