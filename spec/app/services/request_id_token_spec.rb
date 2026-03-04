require "rails_helper"

describe RequestIdToken do
  let(:verifier) { instance_double(ActiveSupport::MessageVerifier) }

  before do
    allow(ActiveSupport::MessageVerifier).to receive(:new)
      .with("TEST_REQUEST_ID_SECRET", digest: "SHA256")
      .and_return(verifier)
  end

  describe ".encode" do
    it "calls verifier.generate with the chat_id" do
      expect(verifier).to receive(:generate).with(123).and_return("encoded-token")

      result = RequestIdToken.encode(123)
      expect(result).to eq("encoded-token")
    end
  end

  describe ".decode" do
    it "calls verifier.verify with the token" do
      expect(verifier).to receive(:verify)
        .with("encoded-token")
        .and_return(123)

      result = RequestIdToken.decode("encoded-token")
      expect(result).to eq(123)
    end
  end

  describe ".verifier" do
    it "builds an ActiveSupport::MessageVerifier with correct args" do
      expect(RequestIdToken.verifier).to eq(verifier)
    end
  end
end
