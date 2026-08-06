module Flipper
  class SyncDesiredFlags
    include Interactor

    delegate :desired, to: :context

    def call
      context.desired_keys = desired_keys

      desired.each do |name, enabled|
        enabled ? ::Flipper.enable(name) : ::Flipper.disable(name)
      end
    end

    private

    def desired_keys
      desired.keys.map(&:to_s)
    end
  end
end
