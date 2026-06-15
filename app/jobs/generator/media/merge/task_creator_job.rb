module Generator
  module Media
    module Merge
      class TaskCreatorJob < ApplicationJob
        include Memery

        def perform(button_request_id)
          @button_request_id = button_request_id

          SuccessNotifierJob.perform_async(url, button_request_id)
        rescue StandardError => e
          ErrorNotifierJob.perform_async(button_request_id)
          raise e
        end

        private

        delegate :url, to: :task_creator

        attr_reader :button_request_id

        memoize def request
          ButtonMergeAudioVideoProcessingRequest
            .includes(:parent_request, command_request: :user)
            .find(button_request_id)
        end

        memoize def task_creator
          CreateTask::TaskCreator.new(request)
        end
      end
    end
  end
end
