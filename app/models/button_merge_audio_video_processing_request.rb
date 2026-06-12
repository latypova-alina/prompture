class ButtonMergeAudioVideoProcessingRequest < ApplicationRecord
  include HasOriginPrompt
  include HasOriginTelegramMessage

  PROCESSOR_TYPES = %w[ffmpeg_merge_audio_video].freeze

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true

  has_one :bot_telegram_message, as: :request, dependent: :destroy
  has_one :stored_video, as: :source, dependent: :destroy

  validates :processor, presence: true, inclusion: { in: PROCESSOR_TYPES }
  validates :source_video_url, :source_audio_url, presence: true

  delegate :user, :chat_id, to: :command_request
  delegate :locale, to: :user

  def cost
    COSTS[:merge_audio_video][processor.to_sym]
  end

  def humanized_process_name
    I18n.t("telegram.generation.humanized_process_names.merge.#{processor}", locale:)
  end
end
