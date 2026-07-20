require "rails_helper"

describe Generator::Media::Image::NotifySuccess::ForBloomy::PresenterFactory do
  subject(:factory) { described_class.new(image_url:, request:, balance:) }

  let(:image_url) { "http://example.com/image.png" }
  let(:balance) { 4 }
  let(:user) { create(:user) }
  let(:command_request) do
    create(
      :command_edit_image_request,
      user:,
      category: ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT
    )
  end
  let(:request) do
    create(
      :button_image_processing_request,
      user:,
      command_request:,
      parent_request: command_request,
      processor: "nano_banana_edit_image"
    )
  end
  let(:presenter_instance) { double }

  before do
    allow(
      MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForBloomy::ForShortComplexScript
    ).to receive(:new)
      .with(
        message: image_url,
        locale: request.locale,
        balance:,
        processor_name: request.humanized_process_name,
        processor: request.processor
      )
      .and_return(presenter_instance)
  end

  describe "#presenter" do
    it "returns the complex shorts edit image presenter" do
      expect(factory.presenter).to eq(presenter_instance)
    end
  end
end
