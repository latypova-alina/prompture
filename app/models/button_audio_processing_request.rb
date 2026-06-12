class ButtonAudioProcessingRequest < ApplicationRecord
  include HasOriginPrompt
  include HasOriginTelegramMessage

  PROCESSOR_TYPES = %w[elevenlabs_v3_audio].freeze
  VOICE_TYPES = Audio::VoiceCatalog.slugs.map(&:to_s).freeze

  belongs_to :parent_request, polymorphic: true
  belongs_to :command_request, polymorphic: true
  belongs_to :audio_prompt, optional: true

  has_one :bot_telegram_message, as: :request, dependent: :destroy

  validates :processor, presence: true, inclusion: { in: PROCESSOR_TYPES }
  validates :voice, presence: true, inclusion: { in: VOICE_TYPES }

  delegate :user, :chat_id, to: :command_request
  delegate :locale, to: :user

  def cost
    COSTS[:generate_audio][processor.to_sym]
  end

  def voice_id
    Audio::VoiceCatalog.voice_id(processor:, slug: voice)
  end

  def humanized_process_name
    I18n.t("telegram.generation.humanized_process_names.audio.voices.#{voice}", locale:)
  end
end
