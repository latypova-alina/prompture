class User < ApplicationRecord
  has_one :balance, dependent: :destroy
  has_many :tokens, dependent: :destroy

  has_many :command_prompt_to_video_requests, dependent: :destroy
  has_many :command_prompt_to_image_requests, dependent: :destroy
  has_many :command_image_to_video_requests, dependent: :destroy
  has_many :command_image_from_reference_requests, dependent: :destroy
end
