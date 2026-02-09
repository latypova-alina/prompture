class CommandImageToVideoRequest < ApplicationRecord
  # TODO: fill this model later

  has_many :button_video_processing_requests, as: :parent_request, dependent: :destroy
end
