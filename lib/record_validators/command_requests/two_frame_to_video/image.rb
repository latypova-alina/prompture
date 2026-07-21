module RecordValidators
  module CommandRequests
    module TwoFrameToVideo
      class Image < ImageToVideo
        def initialize(context:, command_request:)
          super(context:)
          @command_request = command_request
        end

        def validate
          raise MessageTypeError if command_request.frames_ready?

          super
        end

        private

        attr_reader :command_request
      end
    end
  end
end
