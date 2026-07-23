module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module Merge
        class HandleButton
          include Interactor::Organizer

          organize FindParentRequest,
                   SetContext,
                   FindCommandRequest,
                   ValidateRequest,
                   AcknowledgeCallbackQuery,
                   CreateRequest,
                   DecrementBalance,
                   SendGenerationTask
        end
      end
    end
  end
end
