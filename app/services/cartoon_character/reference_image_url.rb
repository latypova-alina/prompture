module CartoonCharacter
  class ReferenceImageUrl
    def self.call
      ENV.fetch("CHARACTER_IMAGE_URL")
    end
  end
end
