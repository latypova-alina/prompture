class CommandImageToVideoRequest < ApplicationRecord
  belongs_to :user

  has_many :button_video_processing_requests, as: :parent_request, dependent: :destroy
end
