module Strategies
  class Selector
    IMAGE_ACTIONS = %w[mystic_image gemini_image].freeze

    def initialize(button_request, session)
      @button_request = button_request
      @session = session
    end

    def strategy
      case button_request
      when "extend_prompt"
        ExtendPrompt.new(session)
      when *IMAGE_ACTIONS
        GenerateImage.new(session, button_request)
      end
    end

    private

    attr_reader :button_request, :session
  end
end
