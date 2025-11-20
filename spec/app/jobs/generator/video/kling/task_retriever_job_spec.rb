require "rails_helper"

describe Generator::Video::Kling::TaskRetrieverJob do
  let(:task_id) { "abc123" }
  let(:chat_id) { 456 }
  let(:job) { described_class.new }

  before do
    allow(Generator::Video::SuccessNotifierJob).to receive(:perform_async)
    allow(Generator::Video::ErrorNotifierJob).to receive(:perform_async)
  end

  subject { job.perform(task_id, chat_id) }

  describe "#video_url" do
    include_context "stub retrieve kling task success request"

    it "extracts the generated video URL from the response body" do
      subject

      expect(job.video_url).to eq("https://ai-statics.freepik.com/completed_task_video.mp4")
    end
  end

  describe "#perform" do
    context "when the API response is successful" do
      include_context "stub retrieve kling task success request"

      it "enqueues SuccessNotifierJob with the extracted video_url" do
        subject

        expect(Generator::Video::SuccessNotifierJob).to have_received(:perform_async)
          .with("https://ai-statics.freepik.com/completed_task_video.mp4", chat_id)
      end

      it "does not enqueue ErrorNotifierJob" do
        subject

        expect(Generator::Video::ErrorNotifierJob).not_to have_received(:perform_async)
      end
    end

    context "when the API response is NOT successful" do
      include_context "stub retrieve kling task fail request"

      it "rescues the error and enqueues ErrorNotifierJob" do
        subject

        expect(Generator::Video::ErrorNotifierJob).to have_received(:perform_async)
          .with(chat_id)
      end

      it "does not enqueue SuccessNotifierJob" do
        subject

        expect(Generator::Video::SuccessNotifierJob).not_to have_received(:perform_async)
      end
    end
  end
end
