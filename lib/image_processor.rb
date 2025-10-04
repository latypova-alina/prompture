class ImageProcessor
  include Memery

  IMAGE_PROCESSORS = {
    "mystic" => ::MysticImageProcessor
  }.freeze

  def initialize(prompt, processor_type)
    @prompt = prompt
    @processor_type = processor_type
  end

  delegate :image_url, to: :corresponding_processor

  private

  attr_reader :prompt, :processor_type

  memoize def corresponding_processor
    IMAGE_PROCESSORS[processor_type].new(prompt)
  end
end
