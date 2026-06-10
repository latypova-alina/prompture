class CommandPromptToVideoRequest < ApplicationRecord
  include HasOriginPrompt
  include CartoonScriptCheckable

  belongs_to :user

  validates :category, format: { with: ContentCategory::CATEGORY_FORMAT }, allow_nil: true

  has_many :button_extend_prompt_requests, as: :command_request, dependent: :destroy
  has_many :button_image_processing_requests, as: :command_request, dependent: :destroy
  has_many :button_video_processing_requests, as: :command_request, dependent: :destroy
  has_many :prompt_messages, as: :command_request, dependent: :destroy

  has_many :direct_button_extend_prompt_requests,
           as: :parent_request,
           class_name: "ButtonExtendPromptRequest",
           dependent: :destroy

  has_many :direct_button_image_processing_requests,
           as: :parent_request,
           class_name: "ButtonImageProcessingRequest",
           dependent: :destroy

  has_many :direct_button_video_processing_requests,
           as: :parent_request,
           class_name: "ButtonVideoProcessingRequest",
           dependent: :destroy
end
