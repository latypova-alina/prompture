module Generator
  module Media
    module Image
      module CreateTask
        class PayloadComposer < Generator::Media::CreateTask::PayloadComposerBase
          EDIT_PROCESSORS = %w[nano_banana_edit_image].freeze

          def final_payload
            return payload.merge(image_urls: [input_image_url]) if edit_processor?

            payload
          end

          private

          delegate :payload, to: :strategy

          def edit_processor?
            EDIT_PROCESSORS.include?(request.processor)
          end

          def input_image_url
            request.parent_request.resolved_image_url
          end
        end
      end
    end
  end
end
