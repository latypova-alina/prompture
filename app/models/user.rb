class User < ApplicationRecord
  has_one :balance, dependent: :destroy
  has_many :tokens, dependent: :destroy
  has_many :balance_transactions, dependent: :destroy

  has_many :command_prompt_to_video_requests, dependent: :destroy
  has_many :command_prompt_to_image_requests, dependent: :destroy
  has_many :command_image_to_video_requests, dependent: :destroy
  has_many :command_two_frame_to_video_requests, dependent: :destroy
  has_many :command_edit_image_requests, dependent: :destroy
  has_many :command_prompt_to_audio_requests, dependent: :destroy
end
