module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module MultiSceneScript
        class HandleButton
          include Interactor::Organizer

          organize FindParentRequest,
                   FindCommandRequest,
                   FindScene,
                   AcknowledgeCallbackQuery,
                   CreateVideoRequest,
                   DecrementBalance,
                   SendGenerationTask
        end
      end
    end
  end
end
