class CommandEditImageRequest < ApplicationRecord
  belongs_to :user

  has_many :button_image_processing_requests, as: :parent_request, dependent: :destroy

  def latest_image_message
    candidates = [
      UserPictureMessage.where(command_request: self).order(created_at: :desc).first,
      UserImageUrlMessage.where(command_request: self).order(created_at: :desc).first
    ].compact

    candidates.max_by(&:created_at)
  end
end
