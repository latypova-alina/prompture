module Buttons
  class ForAudioMessage < Buttons::Base
    def build
      [[send_as_separate_message_button]]
    end
  end
end
