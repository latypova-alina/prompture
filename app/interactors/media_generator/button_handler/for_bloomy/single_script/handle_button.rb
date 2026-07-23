module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module SingleScript
        class HandleButton
          include Interactor::Organizer

          organize FindParentRequest,
                   FindCommandRequest,
                   ValidateRequest,
                   AcknowledgeCallbackQuery,
                   EnqueueProcess
        end
      end
    end
  end
end
