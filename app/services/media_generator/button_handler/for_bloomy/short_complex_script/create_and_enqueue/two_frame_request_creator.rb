module MediaGenerator
  module ButtonHandler
    module ForBloomy
      module ShortComplexScript
        module CreateAndEnqueue
          class TwoFrameRequestCreator
            include Memery

            def initialize(start_scene:, end_scene:, command_request:)
              @start_scene = start_scene
              @end_scene = end_scene
              @command_request = command_request
            end

            def two_frame_request
              raise ImageNotReadyError if start_image_url.blank? || end_image_url.blank?

              CommandTwoFrameToVideoRequest.create!(
                chat_id:,
                user:,
                start_image_url:,
                end_image_url:
              )
            end

            private

            attr_reader :start_scene, :end_scene, :command_request

            delegate :user, :chat_id, to: :command_request
            delegate :start_image_url, :end_image_url, to: :image_resolver

            memoize def image_resolver
              StartEndImageResolver.new(start_scene:, end_scene:)
            end
          end
        end
      end
    end
  end
end
