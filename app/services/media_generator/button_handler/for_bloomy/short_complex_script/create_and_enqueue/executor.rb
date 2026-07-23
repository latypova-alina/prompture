module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        module CreateAndEnqueue
          class Executor
            include Memery

            def self.call(...)
              new(...).call
            end

            def initialize(start_scene:, end_scene:, command_request:)
              @start_scene = start_scene
              @end_scene = end_scene
              @command_request = command_request
            end

            def call
              raise InsufficientCreditsError if balance_result.failure?

              Generator::Media::Video::EnqueueVideoTask.call(button_request_record)
            end

            private

            attr_reader :start_scene, :end_scene, :command_request

            delegate :two_frame_request, to: :two_frame_request_creator

            memoize def balance_result
              MediaGenerator::ButtonHandler::DecrementBalance.call(
                command_request:,
                button_request_record:
              )
            end

            memoize def button_request_record
              button_request_creator.button_request_record
            end

            memoize def button_request_creator
              ButtonRequestCreator.new(two_frame_request:)
            end

            memoize def two_frame_request_creator
              TwoFrameRequestCreator.new(start_scene:, end_scene:, command_request:)
            end
          end
        end
      end
    end
  end
end
