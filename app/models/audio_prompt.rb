class AudioPrompt < ApplicationRecord
  belongs_to :video_prompt

  validates :prompt, presence: true
end
