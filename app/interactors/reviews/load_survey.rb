module Reviews
  # What the review mini app loads first: who the user is (from initData), whether they've already
  # reviewed, and the survey localized to their language.
  class LoadSurvey
    include Interactor::Organizer

    organize MiniApp::BuyStones::ValidateInitData,
             MiniApp::BuyStones::ResolveUser,
             LoadSurvey::BuildSurvey
  end
end
