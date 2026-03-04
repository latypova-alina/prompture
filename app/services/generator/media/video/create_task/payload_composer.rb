module Generator
  module Media
    module Video
      module CreateTask
        class PayloadComposer < Generator::Media::CreateTask::PayloadComposerBase
          def final_payload
            strategy.payload.reverse_merge(webhook_url:, image: image_url)
          end

          delegate :image_url, to: :request
        end
      end
    end
  end
end
