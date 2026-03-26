# spec/services/generator/media/image/notify_success/presenter_selector_spec.rb

require "rails_helper"

describe Generator::Media::Image::NotifySuccess::PresenterSelector do
  subject(:selector) do
    described_class.new(image_url: image_url, request: request, balance:)
  end

  let(:image_url) { "http://example.com/image.png" }
  let(:balance) { 5 }

  let(:command_request) { create(:command_prompt_to_image_request) }
  let(:request) { create(:button_image_processing_request, command_request:) }

  let(:inner_selector_instance) { double }
  let(:presenter_instance) { double }

  before do
    allow(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector)
      .to receive(:new)
      .with(image_url, "CommandPromptToImageRequest", "en", balance)
      .and_return(inner_selector_instance)

    allow(inner_selector_instance)
      .to receive(:presenter)
      .and_return(presenter_instance)
  end

  describe "#presenter" do
    it "returns presenter from inner selector" do
      expect(selector.presenter).to eq(presenter_instance)
    end
  end
end
