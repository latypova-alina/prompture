module MediaGenerator
  module ButtonHandler
    class SendAsSeparateMessage
      include Interactor::Organizer

      organize FindParentRequest, ResendMediaMessage
    end
  end
end
