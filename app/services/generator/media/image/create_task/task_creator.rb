module Generator
  module Media
    module Image
      module CreateTask
        class TaskCreator < Generator::Media::CreateTask::TaskCreatorBase
          def call
            super

            send_interim_message
          end

          private

          def send_interim_message
            Generator::Media::Interim::MessageSender.call(request:)
          end

          delegate :webhook_url, to: :payload_composer

          def api_client
            FalApiClient.new(api_url, final_payload, webhook_url)
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
