module Strategies
  class ExtendPrompt
    def initialize(session)
      @raw_prompt = session["prompt"]
      @session = session
      
      update_session
    end

    delegate :reply_data, to: :presenter

    private

    attr_reader :raw_prompt, :session

    delegate :extended_prompt, to: :extended_prompt_object

    def update_session
      session["prompt"] = extended_prompt
    end

    def extended_prompt_object
      ExtendedPrompt.new(raw_prompt, "extend_description")
    end

    def presenter
      MessagePresenter.new(extended_prompt, "prompt_message")
    end
  end
end