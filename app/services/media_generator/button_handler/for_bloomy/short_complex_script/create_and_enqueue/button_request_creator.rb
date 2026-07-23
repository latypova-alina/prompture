module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        module CreateAndEnqueue
          class ButtonRequestCreator
            def initialize(two_frame_request:)
              @two_frame_request = two_frame_request
            end

            def button_request_record
              RecordCreators::ButtonRequests::Videos::Kling3Standard
                .new(two_frame_request, two_frame_request)
                .record
            end

            private

            attr_reader :two_frame_request
          end
        end
      end
    end
  end
end
