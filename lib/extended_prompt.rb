class ExtendedPrompt
  VALID_REQUEST = "extend_description".freeze

  def initialize(prompt, button_request)
    @prompt = prompt
    @button_request = button_request
  end

  def extended_prompt
    return prompt unless button_request == VALID_REQUEST
    
    ExtendPrompt.call(prompt:).extended_prompt
  end

  private

  attr_reader :prompt, :button_request
end
