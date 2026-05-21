module RecordCreators
  module ButtonRequests
    module Audio
      class ElevenlabsTurbo < RecordCreators::Base
        def initialize(parent_request, command_request, voice:)
          @voice = voice.to_s
          super(parent_request, command_request)
        end

        def record
          ::ButtonAudioProcessingRequest.create!(
            status: "PENDING",
            parent_request:,
            processor:,
            voice:,
            command_request:
          )
        end

        private

        attr_reader :voice

        def processor
          "elevenlabs_turbo_v2_5_audio"
        end
      end
    end
  end
end
