module MiniApp
  module BuyStones
    class ValidateInitData
      include Interactor
      include Memery

      delegate :init_data, to: :context

      def call
        context.fail!(error: MiniApp::InvalidInitDataError) unless validator.valid?
      end

      private

      memoize def validator
        MiniApp::InitDataValidator.new(init_data:)
      end
    end
  end
end
