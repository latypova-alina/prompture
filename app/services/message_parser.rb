MessageParser = Struct.new(:message) do
  def message_text
    message["text"]
  end

  def chat_id
    message["chat"]["id"]
  end
end
