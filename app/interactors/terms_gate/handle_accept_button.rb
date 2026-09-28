module TermsGate
  class HandleAcceptButton
    include Interactor::Organizer

    organize FindUser, AcknowledgeCallbackQuery, MiniApp::BuyStones::AcceptTerms, EditGateMessage
  end
end
