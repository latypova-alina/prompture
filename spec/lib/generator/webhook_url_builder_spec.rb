require "rails_helper"

describe Generator::WebhookUrlBuilder do
  subject { described_class.new(button_request, request_id, chat_id).webhook_url }

  let(:button_request) { "mystic_image" }
  let(:request_id) { 123 }
  let(:chat_id) { 456 }
  let(:token) { "encoded-token" }

  before do
    allow(ChatToken)
      .to receive(:encode)
      .with(chat_id)
      .and_return(token)
  end

  context "when environment is not production" do
    let(:base_url) { "https://example.com" }

    before do
      allow(Rails.env).to receive(:production?).and_return(false)
      ENV["GENERATOR_WEBHOOK_BASE_URL"] = base_url
    end

    it "builds webhook url using generator webhook base url" do
      expect(subject).to eq(
        "#{base_url}/freepik_webhook" \
        "?token=#{token}&button_request=#{button_request}&request_id=#{request_id}"
      )
    end
  end

  context "when environment is production" do
    let(:base_url) { "https://prod.example.com" }

    before do
      allow(Rails.env).to receive(:production?).and_return(true)
      ENV["PRODUCTION_BASE_URL"] = base_url
    end

    it "builds webhook url using production base url" do
      expect(subject).to eq(
        "#{base_url}/freepik_webhook" \
        "?token=#{token}&button_request=#{button_request}&request_id=#{request_id}"
      )
    end
  end
end
