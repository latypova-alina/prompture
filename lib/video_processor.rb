class VideoProcessor
  def initialize(image_url, processor_type)
    @image_url = image_url
    @processor_type = processor_type
  end

  def video_url
    result = BuildVideo::BuildVideo.call(image_url:, processor_type:)

    return nil if result.failure?

    result.video_url.last
  end

  private

  attr_reader :image_url, :processor_type
end
