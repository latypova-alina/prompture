require "rails_helper"

describe MediaGenerator::GenerationStatus::PresenterSelector do
  subject(:presenter) { described_class.new(request:).presenter }

  context "when request is a video processing request" do
    let(:request) { create(:button_video_processing_request) }

    it "returns cancellable presenter" do
      expect(presenter).to be_a(MediaGenerator::GenerationStatus::ForCancellablePresenter)
    end
  end

  context "when request is an image processing request" do
    let(:request) { create(:button_image_processing_request) }

    it "returns non-cancellable presenter" do
      expect(presenter).to be_a(MediaGenerator::GenerationStatus::ForNonCancellablePresenter)
    end
  end
end
