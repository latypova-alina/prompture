class CommandPromptToAudioRequest < ApplicationRecord
  include HasOriginPrompt
  include CartoonScriptCheckable

  belongs_to :user

  validates :category, format: { with: ContentCategory::CATEGORY_FORMAT }, allow_nil: true

  has_many :button_audio_processing_requests, as: :command_request, dependent: :destroy
  has_many :prompt_messages, as: :command_request, dependent: :destroy

  has_many :direct_button_audio_processing_requests,
           as: :parent_request,
           class_name: "ButtonAudioProcessingRequest",
           dependent: :destroy
end
