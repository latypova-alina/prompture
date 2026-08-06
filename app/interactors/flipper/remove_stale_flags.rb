module Flipper
  class RemoveStaleFlags
    include Interactor

    delegate :desired_keys, to: :context

    def call
      stale_flag_names.each { |name| ::Flipper.feature(name).remove }
    end

    private

    def stale_flag_names
      previously_managed_keys - desired_keys
    end

    def previously_managed_keys
      FlipperManagedFeature.pluck(:feature_key)
    end
  end
end
