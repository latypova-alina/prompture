module RecordCreators
  module ButtonRequests
    module Audio
      class ElevenlabsTurbo < Base
        private

        def processor
          "elevenlabs_turbo_v2_5_audio"
        end
      end
    end
  end
end
