module Generator
  module Media
    module Interim
      module Notifier
        class Outdated < Base
          def call
            answer_callback_query_with_alert(
              I18n.t(
                "errors.generation_already_processing",
                processor_name: humanized_process_name
              )
            )
          end
        end
      end
    end
  end
end
