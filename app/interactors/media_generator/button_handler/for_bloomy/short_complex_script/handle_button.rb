module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        class HandleButton
          include Interactor::Organizer

          organize FindParentRequest,
                   ResolveShort,
                   AcknowledgeCallbackQuery,
                   CreateVideoRequests,
                   DeleteCtaMessage
        end
      end
    end
  end
end
