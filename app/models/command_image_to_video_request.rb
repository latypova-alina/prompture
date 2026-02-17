class CommandImageToVideoRequest < ApplicationRecord
  has_many :button_video_processing_requests, as: :parent_request, dependent: :destroy
end
