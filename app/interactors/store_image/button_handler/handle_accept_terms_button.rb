module StoreImage
  module ButtonHandler
    class HandleAcceptTermsButton
      include Interactor::Organizer

      organize ParseButtonRequest, AcknowledgeCallbackQuery, MiniApp::BuyStones::AcceptTerms, EditGateMessage,
               ResumeNotification
    end
  end
end
