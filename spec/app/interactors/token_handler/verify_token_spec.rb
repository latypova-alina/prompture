require "rails_helper"

describe TokenHandler::VerifyToken do
  subject { described_class.call(token_code:) }

  let(:token_code) { token.code }

  describe "#call" do
    context "when token does not exist" do
      let(:token_code) { "INVALID" }

      it "fails with TokenNotFoundError" do
        result = subject

        expect(result).to be_failure
        expect(result.error).to eq(TokenNotFoundError)
      end
    end

    context "when token is already used" do
      let!(:token) { create(:token, used_at: Date.current) }

      it "fails with TokenUsedError" do
        result = subject

        expect(result).to be_failure
        expect(result.error).to eq(TokenUsedError)
      end
    end

    context "when token is expired" do
      let!(:token) { create(:token, expires_at: 1.day.ago) }

      it "fails with TokenExpiredError" do
        result = subject

        expect(result).to be_failure
        expect(result.error).to eq(TokenExpiredError)
      end
    end

    context "when token is valid" do
      let!(:token) do
        create(
          :token,
          used_at: nil,
          expires_at: 1.day.from_now
        )
      end

      it "is successful" do
        expect(subject).to be_success
      end

      it "assigns token to context" do
        expect(subject.token).to eq(token)
      end
    end
  end
end
