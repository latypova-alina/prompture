module Generator
  module Media
    module Image
      module CreateTask
        class PayloadComposer < Generator::Media::CreateTask::PayloadComposerBase
          def final_payload
            strategy.payload
          end

          def webhook_url
            webhook_url_builder.webhook_url
          end
        end
      end
    end
  end
end
