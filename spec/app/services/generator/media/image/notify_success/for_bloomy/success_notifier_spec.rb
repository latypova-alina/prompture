require "rails_helper"

describe Generator::Media::Image::NotifySuccess::ForBloomy::SuccessNotifier do
  subject(:call_service) do
    described_class.call(image_url:, button_request_id: button_request.id)
  end

  let(:image_url) { "http://example.com/image.png" }
  let(:balance) { 7 }
  let(:user) { create(:user, :with_custom_balance, credits: balance) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      user:,
      category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT
    )
  end
  let(:button_request) do
    create(
      :button_image_processing_request,
      status: "PENDING",
      user:,
      command_request:,
      parent_request: command_request
    )
  end

  let(:presenter_factory) { instance_double(Generator::Media::Image::NotifySuccess::ForBloomy::PresenterFactory) }
  let(:presenter_instance) { double }
  let(:reply_data) { { text: "done" } }

  before do
    allow(Generator::Media::Image::NotifySuccess::ForBloomy::PresenterFactory)
      .to receive(:new)
      .with(image_url:, request: button_request, balance:)
      .and_return(presenter_factory)

    allow(presenter_factory)
      .to receive(:presenter)
      .and_return(presenter_instance)

    allow(presenter_instance)
      .to receive(:reply_data)
      .and_return(reply_data)

    allow(Generator::Media::Image::NotifySuccess::SendTelegramMessage)
      .to receive(:call)

    allow(ScriptGenerator::ForBloomy::EnqueueNextChainedScene).to receive(:call)
    allow(ScriptGenerator::ForBloomy::GenerateVideosCta::Generator).to receive(:call)
  end

  describe ".call" do
    it "sends telegram message via bloomy presenter, updates request, and enqueues next chained scene" do
      call_service

      expect(Generator::Media::Image::NotifySuccess::SendTelegramMessage)
        .to have_received(:call)
        .with(reply_data: reply_data, request: button_request)

      expect(button_request.reload.status).to eq("COMPLETED")
      expect(button_request.image_url).to eq(image_url)
      expect(ScriptGenerator::ForBloomy::EnqueueNextChainedScene)
        .to have_received(:call)
        .with(image_url:, button_request:)
      expect(ScriptGenerator::ForBloomy::GenerateVideosCta::Generator)
        .to have_received(:call)
        .with(button_request:)
    end
  end
end
