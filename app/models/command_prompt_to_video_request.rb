class CommandPromptToVideoRequest < ApplicationRecord
  has_many :button_extend_prompt_requests, as: :parent_request
  has_many :button_image_processing_requests, as: :parent_request
  has_many :button_video_processing_requests, as: :parent_request
  has_one :button_parent_message, as: :request, dependent: :destroy

  def extended_prompt
    # TODO: delete this method?
    button_extend_prompt_requests.order(created_at: :desc).first&.extended_prompt
  end
end
