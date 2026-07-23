module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module Audio
        class HandleButton
          include Interactor::Organizer

          organize FindParentRequest,
                   FindCommandRequest,
                   FindScene,
                   AcknowledgeCallbackQuery,
                   CreateRequest,
                   DecrementBalance,
                   SendGenerationTask
        end
      end
    end
  end
end
