# spec/services/generator/media/image/notify_success/presenter_factory_spec.rb

require "rails_helper"

describe Generator::Media::Image::NotifySuccess::PresenterFactory do
  subject(:factory) do
    described_class.new(image_url: image_url, request: request, balance:)
  end

  let(:image_url) { "http://example.com/image.png" }
  let(:balance) { 5 }
  let(:processor_name) { request.humanized_process_name }
  let(:processor) { request.processor }
  let(:context_class) { MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::Context }

  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:request) { create(:button_image_processing_request, command_request:) }

  let(:inner_selector_instance) { double }
  let(:presenter_instance) { double }

  before do
    allow(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector)
      .to receive(:new)
      .with(
        context: an_instance_of(context_class)
      )
      .and_return(inner_selector_instance)

    allow(inner_selector_instance)
      .to receive(:presenter)
      .and_return(presenter_instance)
  end

  describe "#presenter" do
    it "returns presenter from inner selector" do
      expect(factory.presenter).to eq(presenter_instance)

      expect(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector)
        .to have_received(:new)
        .with(
          context: have_attributes(
            image_url:,
            command_request_classname: "CommandPromptToImageRequest",
            locale: "en",
            balance:,
            processor_name:,
            processor:
          )
        )
    end
  end
end
