module Flipper
  class DesiredState
    def self.call
      FLIPPER_FEATURES.keys.index_with { |key| enabled?(key) }
    end

    def self.enabled?(key)
      ENV[key.to_s.upcase] == "true"
    end
  end
end
