module Generator
  module Media
    module Image
      module CreateTask
        class TaskCreator < Generator::Media::CreateTask::TaskCreatorBase
          FAL_API_CLIENT = FluxApiClient

          PROCESSOR_API_CLIENTS = Generator::Processors::IMAGE.index_with { FAL_API_CLIENT }.freeze

          private

          def api_client_class
            PROCESSOR_API_CLIENTS.fetch(request.processor, ApiClient)
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
