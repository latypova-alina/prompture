require "rails_helper"

describe Fal::Webhook::SignedMessage do
  subject(:message) do
    described_class.new(request_id: "req_1", user_id: "user_1", timestamp: "1700000000", body:).to_s
  end

  let(:body) { '{"status":"OK"}' }

  it { is_expected.to eq("req_1\nuser_1\n1700000000\n#{Digest::SHA256.hexdigest(body)}") }
end
