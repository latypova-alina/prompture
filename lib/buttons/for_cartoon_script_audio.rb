module Buttons
  class ForCartoonScriptAudio < Base
    def build
      [[merge_audio_video_button]]
    end

    private

    def merge_audio_video_button
      {
        text: I18n.t(
          "telegram_webhooks.message.buttons.merge_cartoon_audio_video",
          count: merge_cost,
          locale:
        ),
        callback_data: ButtonActions::MERGE_CARTOON_AUDIO_VIDEO
      }
    end

    def merge_cost
      COSTS[:merge_audio_video][:ffmpeg_merge_audio_video]
    end
  end
end
