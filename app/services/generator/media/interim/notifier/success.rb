module Generator
  module Media
    module Interim
      module Notifier
        class Success < Base
          def call
            answer_callback_query_with_alert(
              I18n.t(
                "errors.generation_cancelled_successfully",
                processor_name: humanized_process_name
              )
            )
          end
        end
      end
    end
  end
end
