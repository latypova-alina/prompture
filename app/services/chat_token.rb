class ChatToken
  def self.encode(chat_id)
    verifier.generate(chat_id)
  end

  def self.decode(token)
    verifier.verify(token)
  end

  def self.verifier
    ActiveSupport::MessageVerifier.new(
      ENV.fetch("CHAT_TOKEN_SECRET"),
      digest: "SHA256"
    )
  end
end
