module MiniApp
  module BuyStones
    class LoadPacks
      include Interactor::Organizer

      organize ValidateInitData, ResolveUser, AcceptTerms, BuildPackData
    end
  end
end
