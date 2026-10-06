class User < ApplicationRecord
  has_one :balance, dependent: :destroy
  has_many :tokens, dependent: :destroy
  has_many :balance_transactions, dependent: :destroy
  has_many :policy_acceptances, dependent: :destroy
  has_one :review, dependent: :destroy
  # Conversation history: rows with a user_id go with the association; rows recorded before the
  # user existed only have the chat_id, so those are cleared by chat_id too.
  has_many :chat_events, dependent: :delete_all
  after_destroy { ChatEvent.where(chat_id:, user_id: nil).delete_all }

  has_many :command_prompt_to_video_requests, dependent: :destroy
  has_many :command_prompt_to_image_requests, dependent: :destroy
  has_many :command_image_to_video_requests, dependent: :destroy
  has_many :command_two_frame_to_video_requests, dependent: :destroy
  has_many :command_edit_image_requests, dependent: :destroy
  has_many :command_prompt_to_audio_requests, dependent: :destroy
end
