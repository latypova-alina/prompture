require "rails_helper"

describe Generator::Image::Mystic::TaskRetrieverJob do
  let(:task_id) { "abc123" }
  let(:chat_id) { 456 }
  let(:job) { described_class.new }

  before do
    allow(Generator::Image::SuccessNotifierJob).to receive(:perform_async)
    allow(Generator::Image::ErrorNotifierJob).to receive(:perform_async)
  end

  subject { job.perform(task_id, chat_id) }

  describe "#image_url" do
    include_context "stub retrieve mystic task success request"

    it "extracts the generated image URL from the response body" do
      subject

      expect(job.image_url).to eq("https://ai-statics.freepik.com/completed_task_image.jpg")
    end
  end

  describe "#perform" do
    context "when the API response is successful" do
      include_context "stub retrieve mystic task success request"

      it "enqueues SuccessNotifierJob with the extracted image_url" do
        subject

        expect(Generator::Image::SuccessNotifierJob).to have_received(:perform_async)
          .with("https://ai-statics.freepik.com/completed_task_image.jpg", chat_id)
      end

      it "does not enqueue ErrorNotifierJob" do
        subject

        expect(Generator::Image::ErrorNotifierJob).not_to have_received(:perform_async)
      end
    end

    context "when the API response is NOT successful" do
      include_context "stub retrieve mystic task fail request"

      it "rescues the error and enqueues ErrorNotifierJob" do
        subject

        expect(Generator::Image::ErrorNotifierJob).to have_received(:perform_async)
          .with(chat_id)
      end

      it "does not enqueue SuccessNotifierJob" do
        subject

        expect(Generator::Image::SuccessNotifierJob).not_to have_received(:perform_async)
      end
    end
  end
end
