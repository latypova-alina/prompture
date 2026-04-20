# spec/services/generator/media/image/create_task/task_creator_spec.rb

require "rails_helper"

describe Generator::Media::Image::CreateTask::TaskCreator do
  subject(:call_service) { described_class.call(request) }

  let(:request) { create(:button_image_processing_request) }

  let(:strategy_selector_instance) { instance_double(Generator::Media::Image::CreateTask::StrategySelector) }
  let(:strategy_instance) { instance_double("Strategy", api_url: api_url) }

  let(:payload_composer_instance) { instance_double(Generator::Media::Image::CreateTask::PayloadComposer) }
  let(:final_payload) { { foo: "bar" } }

  let(:api_client_instance) { instance_double(Generator::Media::Image::CreateTask::ApiClient) }
  let(:response) { instance_double("Response", success?: success, status:) }

  let(:api_url) { "https://api.example.com" }
  let(:status) { 200 }

  before do
    allow(Generator::Media::Image::CreateTask::StrategySelector)
      .to receive(:new)
      .with(request)
      .and_return(strategy_selector_instance)

    allow(strategy_selector_instance)
      .to receive(:strategy)
      .and_return(strategy_instance)

    allow(Generator::Media::Image::CreateTask::PayloadComposer)
      .to receive(:new)
      .with(request, strategy_instance)
      .and_return(payload_composer_instance)

    allow(payload_composer_instance)
      .to receive(:final_payload)
      .and_return(final_payload)

    allow(Generator::Media::Image::CreateTask::ApiClient)
      .to receive(:new)
      .with(api_url, final_payload)
      .and_return(api_client_instance)

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
    end

    context "when response is not successful" do
      let(:success) { false }
      let(:status) { 500 }

      it "raises Freepik::ResponseError" do
        expect { call_service }
          .to raise_error(Freepik::ResponseError)
      end
    end

    context "when response status is 429" do
      let(:success) { false }
      let(:status) { 429 }

      it "raises Freepik::DailyLimitExceeded" do
        expect { call_service }
          .to raise_error(Freepik::DailyLimitExceeded)
      end
    end
  end
end
