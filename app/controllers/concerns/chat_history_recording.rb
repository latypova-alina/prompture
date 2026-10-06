# Records every incoming update before anything else runs (including chat authorization, so
# unknown chats and users who never accepted the terms are recorded too). See ChatEvents.
module ChatHistoryRecording
  extend ActiveSupport::Concern

  included { prepend_before_action :record_incoming_update }

  private

  def record_incoming_update
    ChatEvents::IncomingRecorder.call(update)
  end
end
