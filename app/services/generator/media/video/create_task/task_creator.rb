module Generator
  module Media
    module Video
      module CreateTask
        class TaskCreator < Generator::Media::CreateTask::TaskCreatorBase
          private

          delegate :webhook_url, to: :payload_composer

          def api_client
            Generator::Media::Image::CreateTask::FalApiClient.new(api_url, final_payload, webhook_url)
          end

          def payload_composer_class
            PayloadComposer
          end

          def strategy_selector_class
            StrategySelector
          end
        end
      end
    end
  end
end
