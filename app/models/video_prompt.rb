class VideoPrompt < ApplicationRecord
  has_one :script, dependent: :nullify
  has_many :audio_prompts, dependent: :destroy
  has_many :prompt_messages, dependent: :nullify
end
