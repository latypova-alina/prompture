module Generator
  module PromptToVideo
    class TaskRetrieverSelectorJob < ApplicationJob
      RETRIEVER_JOBS = {
        "kling_2_1_pro_image_to_video" => Generator::Video::Kling::PromptToVideo::TaskRetrieverJob
      }.freeze

      def perform(task_id, button_request, request_id, chat_id)
        return unless RETRIEVER_JOBS.key?(button_request)

        RETRIEVER_JOBS[button_request].perform_async(task_id, chat_id, request_id)
      end
    end
  end
end
