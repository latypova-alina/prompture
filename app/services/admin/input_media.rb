module Admin
  # The viewable image behind a user's input message - the bucket copy for Telegram pictures/files
  # (which otherwise only have a Telegram file id), or the stored/original URL for image URL messages.
  module InputMedia
    IMAGE_MESSAGE_TYPES = [UserPictureMessage, UserImageUrlMessage, UserFileMessage].freeze

    def self.call(input)
      return unless IMAGE_MESSAGE_TYPES.include?(input.class)

      url = input.resolved_image_url
      Admin::MediaItem.new(label: "Input image", kind: :image, url:) if url.present?
    end
  end
end
