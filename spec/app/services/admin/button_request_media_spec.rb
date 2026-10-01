require "rails_helper"

describe Admin::ButtonRequestMedia do
  let(:media) { described_class.new(button_request) }

  describe "#output" do
    subject { media.output }

    context "when an image request has a stored copy" do
      let(:button_request) { create(:button_image_processing_request, :completed) }

      before { create(:stored_image, source_message: button_request, image_url: "https://bucket.example.com/a.png") }

      it { is_expected.to have_attributes(kind: :image, url: "https://bucket.example.com/a.png") }
    end

    context "when an audio request has audio" do
      let(:button_request) { create(:button_audio_processing_request, :completed) }

      it { is_expected.to have_attributes(kind: :audio, url: "http://example.com/audio.mp3") }
    end

    context "when the request has no media yet" do
      let(:button_request) { create(:button_image_processing_request) }

      it { is_expected.to be_nil }
    end

    context "when it is an extend prompt request" do
      let(:button_request) { create(:button_extend_prompt_request) }

      it { is_expected.to be_nil }
    end
  end

  describe "#inputs" do
    subject { media.inputs }

    context "when it is a video request" do
      let(:button_request) { create(:button_video_processing_request) }

      it { is_expected.to contain_exactly(have_attributes(kind: :image, url: "http://example.com/image.png")) }
    end

    context "when it is a merge request" do
      let(:button_request) { create(:button_merge_audio_video_processing_request) }

      it { is_expected.to contain_exactly(have_attributes(kind: :video), have_attributes(kind: :audio)) }
    end

    context "when it is an image request" do
      let(:button_request) { create(:button_image_processing_request, :completed) }

      it { is_expected.to be_empty }
    end
  end

  describe "#links" do
    subject { media.links }

    let(:button_request) { create(:button_image_processing_request, :completed) }

    it { is_expected.to eq("Provider URL" => "http://example.com/image.png") }

    context "when there is a stored copy" do
      before { create(:stored_image, source_message: button_request, image_url: "https://bucket.example.com/a.png") }

      it do
        is_expected.to eq("Provider URL" => "http://example.com/image.png",
                          "Stored copy" => "https://bucket.example.com/a.png")
      end
    end
  end
end
