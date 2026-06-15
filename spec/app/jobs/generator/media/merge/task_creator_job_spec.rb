require "rails_helper"

describe Generator::Media::Merge::TaskCreatorJob do
  subject(:perform_job) { described_class.new.perform(button_request.id) }

  let(:button_request) { create(:button_merge_audio_video_processing_request, status: "PENDING") }
  let(:task_creator) { instance_double(Generator::Media::Merge::CreateTask::TaskCreator, url: "https://example.com/merged.mp4") }

  before do
    allow(Generator::Media::Merge::CreateTask::TaskCreator)
      .to receive(:new)
      .and_return(task_creator)
    allow(Generator::Media::Merge::SuccessNotifierJob).to receive(:perform_async)
    allow(Generator::Media::Merge::ErrorNotifierJob).to receive(:perform_async)
  end

  describe "#perform" do
    context "when task creator succeeds" do
      it "enqueues SuccessNotifierJob with the merged url" do
        perform_job

        expect(Generator::Media::Merge::SuccessNotifierJob)
          .to have_received(:perform_async)
          .with("https://example.com/merged.mp4", button_request.id)
      end

      it "does not enqueue ErrorNotifierJob" do
        perform_job

        expect(Generator::Media::Merge::ErrorNotifierJob).not_to have_received(:perform_async)
      end
    end

    context "when task creator raises" do
      before do
        allow(task_creator).to receive(:url).and_raise(StandardError, "ffmpeg failed")
      end

      it "enqueues ErrorNotifierJob" do
        expect { perform_job }.to raise_error(StandardError)

        expect(Generator::Media::Merge::ErrorNotifierJob)
          .to have_received(:perform_async)
          .with(button_request.id)
      end
    end
  end
end
