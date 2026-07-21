class CommandTwoFrameToVideoRequest < ApplicationRecord
  belongs_to :user

  has_many :button_video_processing_requests, as: :parent_request, dependent: :destroy
  has_many :prompt_messages, as: :command_request, dependent: :destroy
  has_many :user_picture_messages, as: :command_request, dependent: :destroy
  has_many :user_image_url_messages, as: :command_request, dependent: :destroy
  has_many :user_file_messages, as: :command_request, dependent: :destroy
end
