class CommandPromptToVideoRequest < ApplicationRecord
  has_many :button_extend_prompt_requests, as: :parent_request
  has_many :button_image_processing_requests, as: :parent_request
  has_many :button_video_processing_requests, as: :parent_request
end
