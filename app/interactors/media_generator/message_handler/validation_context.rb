module MediaGenerator
  module MessageHandler
    ValidationContext = Struct.new(:message_text, :chat_id, :picture_id, :command, :url, keyword_init: true)
  end
end
