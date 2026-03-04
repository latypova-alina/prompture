class RequestIdToken
  def self.encode(request_id)
    verifier.generate(request_id)
  end

  def self.decode(token)
    verifier.verify(token)
  end

  def self.verifier
    ActiveSupport::MessageVerifier.new(
      ENV.fetch("REQUEST_ID_SECRET"),
      digest: "SHA256"
    )
  end
end
