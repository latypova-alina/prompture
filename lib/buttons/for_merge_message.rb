module Buttons
  class ForMergeMessage < Buttons::Base
    def build
      [[send_as_separate_message_button]]
    end
  end
end
