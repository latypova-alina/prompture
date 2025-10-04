class MessagePresenter < BasePresenter
  include Memery

  PRESENTER_CLASSES = {
    "prompt_message" => ::PromptMessagePresenter
  }.freeze

  def initialize(message, message_type)
    @message = message
    @message_type = message_type
  end

  private

  attr_reader :message, :message_type

  delegate :formatted_text, :inline_keyboard, to: :corresponding_class

  memoize def corresponding_class
    PromptMessagePresenter.new(message)
  end
end
