module Generator
  module Media
    module Video
      module CreateTask
        module PayloadEnhancers
          class Default
            def self.applies_to?(_request)
              true
            end

            def initialize(payload:, **)
              @payload = payload
            end

            def enhance
              payload
            end

            private

            attr_reader :payload
          end
        end
      end
    end
  end
end
