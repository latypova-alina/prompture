module Generator
  module Media
    module Interim
      module Notifier
        class Fail < Base
          def call
            notify_user(I18n.t("errors.generation_cancel_failed"))

            answer_callback_query
          end
        end
      end
    end
  end
end
