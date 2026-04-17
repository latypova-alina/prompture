require "rails_helper"

describe MediaGenerator::ButtonHandler::SendGenerationTask do
  subject do
    described_class.call(button_request:, button_request_record:, command_request: parent_request.command_request)
  end

  let(:parent_prompt) { "cute white kitten" }
  let(:parent_request) { create(:prompt_message, prompt: parent_prompt) }
  let(:button_request_record) { create(:button_extend_prompt_request, parent_request:) }
  let(:user) { parent_request.command_request.user }

  before do
    allow(Generator::Prompt::ExtendJob).to receive(:perform_async)
    allow(Generator::Media::Prompt::TaskCreatorJob).to receive(:perform_async)
    allow(Generator::Media::Image::TaskCreatorJob).to receive(:perform_async)
    allow(Generator::Media::Video::TaskCreatorJob).to receive(:perform_async)
  end

  context "when button_request is extend_prompt" do
    let(:button_request) { "extend_prompt" }

    context "when improve_prompt_with_freepik is enabled for user" do
      before do
        allow(Flipper[:improve_prompt_with_freepik])
          .to receive(:enabled?)
          .with(user)
          .and_return(true)
      end

      it "enqueues prompt extension job via Freepik flow" do
        subject

        expect(Generator::Media::Prompt::TaskCreatorJob)
          .to have_received(:perform_async)
          .with(button_request_record.id)

        expect(Generator::Prompt::ExtendJob).not_to have_received(:perform_async)
      end
    end

    context "when improve_prompt_with_freepik is disabled for user" do
      before do
        allow(Flipper[:improve_prompt_with_freepik])
          .to receive(:enabled?)
          .with(user)
          .and_return(false)
      end

      it "enqueues legacy ExtendJob" do
        subject

        expect(Generator::Prompt::ExtendJob)
          .to have_received(:perform_async)
          .with(button_request_record.id)

        expect(Generator::Media::Prompt::TaskCreatorJob).not_to have_received(:perform_async)
      end
    end
  end

  context "when button_request is mystic_image" do
    let(:button_request) { "mystic_image" }

    it "enqueues image generator job" do
      subject

      expect(Generator::Media::Image::TaskCreatorJob)
        .to have_received(:perform_async)
        .with(button_request_record.id)
    end
  end

  context "when button_request is kling_2_1_pro_image_to_video" do
    let(:button_request) { "kling_2_1_pro_image_to_video" }

    it "enqueues video generator job" do
      subject

      expect(Generator::Media::Video::TaskCreatorJob)
        .to have_received(:perform_async)
        .with(button_request_record.id)
    end
  end

  context "when button_request is seedance_1_5_pro_image_to_video" do
    let(:button_request) { "seedance_1_5_pro_image_to_video" }

    it "enqueues video generator job" do
      subject

      expect(Generator::Media::Video::TaskCreatorJob)
        .to have_received(:perform_async)
        .with(button_request_record.id)
    end
  end
end
