require "rails_helper"

describe Generator::Media::WebhookUrlBuilder do
  subject(:webhook_url) do
    described_class.new(processor:, button_request_id:).webhook_url
  end

  let(:processor) { "imagen_image" }
  let(:button_request_id) { 123 }
  let(:encoded_token) { "encoded_token" }

  before do
    allow(RequestIdToken)
      .to receive(:encode)
      .with(button_request_id)
      .and_return(encoded_token)
  end

  describe "#webhook_url" do
    context "when not in production" do
      before do
        allow(Rails.env).to receive(:production?).and_return(false)
        stub_const("ENV", ENV.to_hash.merge("GENERATOR_WEBHOOK_BASE_URL" => "http://localhost:3000"))
      end

      it "builds webhook url using GENERATOR_WEBHOOK_BASE_URL" do
        expect(webhook_url).to eq(
          "http://localhost:3000/freepik_webhook?request_id_token=#{encoded_token}&processor=#{processor}"
        )
      end
    end

    %w[flux_image nano_banana_image].each do |fal_processor|
      context "when processor is #{fal_processor}" do
        let(:processor) { fal_processor }

        before do
          allow(Rails.env).to receive(:production?).and_return(false)
          stub_const("ENV", ENV.to_hash.merge("GENERATOR_WEBHOOK_BASE_URL" => "http://localhost:3000"))
        end

        it "builds webhook url using fal webhook path" do
          expect(webhook_url).to eq(
            "http://localhost:3000/api/fal/webhook?request_id_token=#{encoded_token}&processor=#{processor}"
          )
        end
      end
    end

    context "when in production" do
      before do
        allow(Rails.env).to receive(:production?).and_return(true)
        stub_const("ENV", ENV.to_hash.merge("PRODUCTION_BASE_URL" => "https://app.example.com"))
      end

      it "builds webhook url using PRODUCTION_BASE_URL" do
        expect(webhook_url).to eq(
          "https://app.example.com/freepik_webhook?request_id_token=#{encoded_token}&processor=#{processor}"
        )
      end
    end
  end
end
