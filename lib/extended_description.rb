class ExtendedDescription
  def initialize(message)
    @message = message
  end

  def description
    ExtendDescription.call(message:).description
  end

  private

  attr_reader :message
end
