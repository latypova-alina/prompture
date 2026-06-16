require "rails_helper"

describe Generator::Media::Video::CreateTask::TaskCreator do
  subject(:call_service) { described_class.call(request) }

  let(:request) { create(:button_video_processing_request) }

  let(:strategy_selector_instance) { instance_double(Generator::Media::Video::CreateTask::StrategySelector) }
  let(:strategy_instance) { instance_double("Strategy", api_url: api_url) }

  let(:payload_composer_instance) { instance_double(Generator::Media::Video::CreateTask::PayloadComposer) }
  let(:final_payload) { { foo: "bar" } }
  let(:webhook_url) { "https://example.com/webhook" }

  let(:api_client_instance) { instance_double(Generator::Media::Image::CreateTask::FalApiClient) }
  let(:response) { instance_double("Response", success?: success, status:, body: '{"request_id":"test-123"}') }

  let(:api_url) { "https://api.example.com" }
  let(:status) { 200 }

  before do
    allow(Generator::Media::Video::CreateTask::StrategySelector)
      .to receive(:new)
      .with(request)
      .and_return(strategy_selector_instance)

    allow(strategy_selector_instance)
      .to receive(:strategy)
      .and_return(strategy_instance)

    allow(Generator::Media::Video::CreateTask::PayloadComposer)
      .to receive(:new)
      .with(request, strategy_instance)
      .and_return(payload_composer_instance)

    allow(payload_composer_instance)
      .to receive(:final_payload)
      .and_return(final_payload)

    allow(payload_composer_instance)
      .to receive(:webhook_url)
      .and_return(webhook_url)

    allow(Generator::Media::Image::CreateTask::FalApiClient)
      .to receive(:new)
      .with(api_url, final_payload, webhook_url)
      .and_return(api_client_instance)

    allow(Generator::Media::Interim::MessageSender).to receive(:call)
    allow(api_client_instance)
      .to receive(:response)
      .and_return(response)
  end

  describe ".call" do
    context "when response is successful" do
      let(:success) { true }

      it "does not raise error" do
        expect { call_service }.not_to raise_error
      end

      it "saves fal request id and sends interim message" do
        call_service

        expect(request.reload.fal_request_id).to eq("test-123")
        expect(Generator::Media::Interim::MessageSender)
          .to have_received(:call)
          .with(request:)
      end
    end

    context "when response is not successful" do
      let(:success) { false }
      let(:status) { 500 }

      it "raises Generator::ResponseError" do
        expect { call_service }
          .to raise_error(Generator::ResponseError)
      end
    end

    context "when response status is 429" do
      let(:success) { false }
      let(:status) { 429 }

      it "raises Generator::DailyLimitExceeded" do
        expect { call_service }
          .to raise_error(Generator::DailyLimitExceeded)
      end
    end
  end
end
