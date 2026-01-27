module ButtonHandler
  class HandleButton
    include Interactor::Organizer

    organize FindButtonParentMessage, FindParentRequest, CreateRequest, CreateButtonChildMessage, SendGenerationTask
  end
end
