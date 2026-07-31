module Buttons
  class ForVideoMessage < Buttons::Base
    def initialize(processor:, **kwargs)
      super(**kwargs)
      @processor = processor
    end

    def build
      [[regenerate_button], [send_as_separate_message_button]]
    end

    private

    attr_reader :processor

    def regenerate_button
      regenerate_button_for(:generate_video, processor)
    end
  end
end
