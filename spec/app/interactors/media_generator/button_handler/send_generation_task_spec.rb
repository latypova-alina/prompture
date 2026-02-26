require "rails_helper"

describe MediaGenerator::ButtonHandler::SendGenerationTask do
  subject { described_class.call(button_request:, button_request_record:, parent_request:, image_url:, chat_id:) }

  let(:chat_id) { 456 }
  let(:image_url) { "https://example.com/image.png" }
  let(:parent_prompt) { "cute white kitten" }
  let(:parent_request) { instance_double("CommandPromptToImageRequest", parent_prompt: parent_prompt) }
  let(:button_request_record) { instance_double("ButtonExtendPromptRequest", id: 123) }

  before do
    allow(Generator::Prompt::ExtendJob).to receive(:perform_async)
    allow(Generator::Image::Mystic::TaskCreatorJob).to receive(:perform_async)
    allow(Generator::Image::Gemini::TaskCreatorJob).to receive(:perform_async)
    allow(Generator::Image::Imagen::TaskCreatorJob).to receive(:perform_async)
    allow(Generator::Video::Kling::TaskCreatorJob).to receive(:perform_async)
  end

  context "when button_request is extend_prompt" do
    let(:button_request) { "extend_prompt" }

    it "enqueues prompt extension job" do
      subject

      expect(Generator::Prompt::ExtendJob)
        .to have_received(:perform_async)
        .with(parent_prompt, chat_id, button_request_record.id)
    end
  end

  context "when button_request is mystic_image" do
    let(:button_request) { "mystic_image" }

    it "enqueues image generator job" do
      subject

      expect(Generator::Image::Mystic::TaskCreatorJob)
        .to have_received(:perform_async)
        .with(parent_prompt, chat_id, button_request, button_request_record.id)
    end
  end

  context "when button_request is gemini_image" do
    let(:button_request) { "gemini_image" }

    it "enqueues image generator job" do
      subject

      expect(Generator::Image::Gemini::TaskCreatorJob)
        .to have_received(:perform_async)
        .with(parent_prompt, chat_id, button_request, button_request_record.id)
    end
  end

  context "when button_request is imagen_image" do
    let(:button_request) { "imagen_image" }

    it "enqueues image generator job" do
      subject

      expect(Generator::Image::Imagen::TaskCreatorJob)
        .to have_received(:perform_async)
        .with(parent_prompt, chat_id, button_request, button_request_record.id)
    end
  end

  context "when button_request is kling_2_1_pro_image_to_video" do
    let(:button_request) { "kling_2_1_pro_image_to_video" }

    it "enqueues video generator job" do
      subject

      expect(Generator::Video::Kling::TaskCreatorJob)
        .to have_received(:perform_async)
        .with(parent_prompt, image_url, chat_id, button_request, button_request_record.id)
    end
  end
end
