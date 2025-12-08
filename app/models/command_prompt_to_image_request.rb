class CommandPromptToImageRequest < ApplicationRecord
  has_many :button_extend_prompt_requests, as: :parent_request, dependent: :destroy
  has_many :button_image_processing_requests, as: :parent_request, dependent: :destroy
end
