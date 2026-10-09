require "rails_helper"

describe Generator::Media::CreateTask::FailureDetails do
  subject { described_class.new(error).reason }

  let(:error) { Generator::ResponseError.new('{"detail":[{"type":"value_error","msg":"Invalid image"}]}') }

  context "when fal rejects the input as a content policy violation" do
    let(:body) { { detail: [{ type: "content_policy_violation", msg: "flagged by a content checker" }] } }
    let(:error) { Generator::ResponseError.new(body.to_json) }

    it { is_expected.to eq("content_flagged") }
  end

  context "when fal returns another error body" do
    it { is_expected.to eq("response_error") }
  end

  context "when fal says the account is locked" do
    let(:error) { Generator::AccessForbidden.new('{"detail":"User is locked."}') }

    it { is_expected.to eq("access_forbidden") }
  end

  context "when the daily limit is hit" do
    let(:error) { Generator::DailyLimitExceeded.new }

    it { is_expected.to eq("daily_limit_exceeded") }
  end

  context "when the body isn't JSON" do
    let(:error) { Generator::ResponseError.new("<html>Bad Gateway</html>") }

    it { is_expected.to eq("response_error") }
  end

  describe "#message" do
    subject { described_class.new(error).message }

    it { is_expected.to eq(error.message) }
  end
end
