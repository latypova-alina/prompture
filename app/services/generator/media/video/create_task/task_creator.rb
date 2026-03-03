module Generator
  module Media
    module Video
      module CreateTask
        class TaskCreator < Generator::Media::CreateTask::TaskCreatorBase
          private

          def api_client_class
            ApiClient
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
