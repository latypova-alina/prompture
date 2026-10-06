module Reviews
  # Mini app review submission. Auth reuses the buy stones mini app steps (initData -> user).
  class Submit
    include Interactor::Organizer

    organize MiniApp::BuyStones::ValidateInitData,
             MiniApp::BuyStones::ResolveUser,
             Submit::EnsureNotReviewed,
             Submit::ValidateAnswers,
             Submit::CreateReview,
             Submit::NotifyAdmin,
             Submit::SendThankYou
  end
end
