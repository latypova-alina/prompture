class MysticImageProcessor
  def initialize(prompt)
    @prompt = prompt
  end

  def image_url
    result = BuildMysticImage::BuildMysticImage.call(prompt:)

    return nil if result.failure?

    result.image_url.last
  end

  private

  attr_reader :prompt
end
