require "rails_helper"

describe MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::PresenterSelector do
  describe "#presenter" do
    let(:image_url) { "http://example.com/image.png" }
    let(:locale) { :ru }
    let(:balance) { 4 }
    let(:processor_name) { "Flux image" }
    let(:processor) { "flux_image" }
    let(:command_request) { nil }
    let(:context) do
      MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::Context.new(
        image_url:,
        command_request:,
        command_request_classname:,
        locale:,
        balance:,
        processor_name:,
        processor:
      )
    end

    context "when command request is prompt to image" do
      let(:command_request) { create(:command_prompt_to_image_request) }
      let(:command_request_classname) { "CommandPromptToImageRequest" }

      subject(:selector) do
        described_class.new(context:)
      end

      let(:presenter_instance) { double }

      before do
        allow(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForPromptToImage)
          .to receive(:new)
          .with(message: image_url, locale:, balance:, processor_name:, processor:)
          .and_return(presenter_instance)
      end

      it "returns ForPromptToImage presenter" do
        expect(selector.presenter).to eq(presenter_instance)
      end
    end

    context "when command request is prompt to video" do
      let(:command_request) { create(:command_prompt_to_video_request) }
      let(:command_request_classname) { "CommandPromptToVideoRequest" }

      subject(:selector) do
        described_class.new(context:)
      end

      let(:presenter_instance) { double }

      before do
        allow(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForPromptToVideo)
          .to receive(:new)
          .with(message: image_url, locale:, balance:, processor_name:, processor:)
          .and_return(presenter_instance)
      end

      it "returns ForPromptToVideo presenter" do
        expect(selector.presenter).to eq(presenter_instance)
      end
    end

    context "when command request is edit image" do
      let(:command_request) { create(:command_edit_image_request) }
      let(:command_request_classname) { "CommandEditImageRequest" }

      subject(:selector) do
        described_class.new(context:)
      end

      let(:presenter_instance) { double }

      before do
        allow(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForEditImage)
          .to receive(:new)
          .with(message: image_url, locale:, balance:, processor_name:, processor:)
          .and_return(presenter_instance)
      end

      it "returns ForEditImage presenter" do
        expect(selector.presenter).to eq(presenter_instance)
      end
    end

    context "when command request is cartoon script edit image" do
      let(:command_request) do
        create(:command_edit_image_request, category: ContentCategory::CARTOON_SCRIPT)
      end
      let(:command_request_classname) { "CommandEditImageRequest" }

      subject(:selector) do
        described_class.new(context:)
      end

      let(:presenter_instance) { double }

      before do
        allow(MediaGenerator::ButtonRequestPresenters::ImageProcessedMessage::ForCartoonScriptEditImage)
          .to receive(:new)
          .with(message: image_url, locale:, balance:, processor_name:, processor:)
          .and_return(presenter_instance)
      end

      it "returns ForCartoonScriptEditImage presenter" do
        expect(selector.presenter).to eq(presenter_instance)
      end
    end
  end
end
