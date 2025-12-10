class CommandPromptToImageRequest < ApplicationRecord
  has_many :button_extend_prompt_requests, as: :parent_request, dependent: :destroy
  has_many :button_image_processing_requests, as: :parent_request, dependent: :destroy

  def extended_prompt
    button_extend_prompt_requests.order(created_at: :desc).first&.extended_prompt
  end
end
