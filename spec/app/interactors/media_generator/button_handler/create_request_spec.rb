require "rails_helper"

describe MediaGenerator::ButtonHandler::CreateRequest do
  subject do
    described_class.call(
      button_request:,
      parent_request:,
      command_request:
    )
  end

  let(:button_request) { "flux_image" }

  let(:parent_request) { create(:prompt_message) }
  let(:command_request) { create(:command_prompt_to_image_request) }

  let(:record_creator_class) { RecordCreators::ButtonRequests::Images::Flux }
  let(:record_creator) { instance_double(record_creator_class, record:) }
  let(:record) { create(:button_image_processing_request) }

  before do
    allow(record_creator_class).to receive(:new).and_return(record_creator)
  end

  it "uses the correct handler" do
    result = subject

    expect(result).to be_success
    expect(result.button_request_record).to eq(record)

    expect(record_creator_class)
      .to have_received(:new)
      .with(parent_request, command_request)
  end

  context "when record creator raises ImageNotReadyError" do
    before do
      allow(record_creator).to receive(:record).and_raise(ImageNotReadyError)
    end

    it "fails with ImageNotReadyError" do
      result = subject

      expect(result).to be_failure
      expect(result.error).to eq(ImageNotReadyError)
    end
  end

  context "when button_request is flux_image" do
    let(:button_request) { "flux_image" }
    let(:record_creator_class) { RecordCreators::ButtonRequests::Images::Flux }

    it "uses the flux image record creator" do
      result = subject

      expect(result).to be_success
      expect(result.button_request_record).to eq(record)

      expect(record_creator_class)
        .to have_received(:new)
        .with(parent_request, command_request)
    end
  end

  context "when button_request is an audio voice slug" do
    let(:button_request) { "milo" }
    let(:record_creator_class) { RecordCreators::ButtonRequests::Audio::ElevenlabsV3 }
    let(:record) { create(:button_audio_processing_request, voice: button_request) }
    let(:command_request) { create(:command_prompt_to_audio_request) }

    it "uses the elevenlabs record creator with the voice" do
      result = subject

      expect(result).to be_success
      expect(result.button_request_record).to eq(record)

      expect(record_creator_class)
        .to have_received(:new)
        .with(parent_request, command_request, voice: button_request)
    end
  end
end
