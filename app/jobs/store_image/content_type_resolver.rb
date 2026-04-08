module StoreImage
  class ContentTypeResolver
    include Memery

    def initialize(filename:)
      @filename = filename
    end

    memoize def content_type
      return "image/png" if extension == ".png"
      return "image/jpeg" if [".jpg", ".jpeg"].include?(extension)

      raise ArgumentError, "Unsupported image extension: #{extension}"
    end

    private

    attr_reader :filename

    def extension
      File.extname(filename).downcase
    end
  end
end
