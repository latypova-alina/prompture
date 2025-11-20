require "rails_helper"

describe Generator::ErrorNotifierJob do
  let(:chat_id) { 123 }

  before do
    allow(Generator::Image::ErrorNotifierJob).to receive(:perform_async)
    allow(Generator::Video::ErrorNotifierJob).to receive(:perform_async)
  end

  describe "#perform" do
    context "when button_request is an image request" do
      described_class::IMAGE_BUTTON_REQUESTS.each do |req|
        it "enqueues Image::ErrorNotifierJob for '#{req}'" do
          described_class.new.perform(req, chat_id)

          expect(Generator::Image::ErrorNotifierJob).to have_received(:perform_async)
            .with(chat_id)

          expect(Generator::Video::ErrorNotifierJob).not_to have_received(:perform_async)
        end
      end
    end

    context "when button_request is a video request" do
      described_class::VIDEO_BUTTON_REQUESTS.each do |req|
        it "enqueues Video::ErrorNotifierJob for '#{req}'" do
          described_class.new.perform(req, chat_id)

          expect(Generator::Video::ErrorNotifierJob).to have_received(:perform_async)
            .with(chat_id)

          expect(Generator::Image::ErrorNotifierJob).not_to have_received(:perform_async)
        end
      end
    end

    context "when button_request is something else" do
      it "does nothing" do
        described_class.new.perform("unknown", chat_id)

        expect(Generator::Image::ErrorNotifierJob).not_to have_received(:perform_async)
        expect(Generator::Video::ErrorNotifierJob).not_to have_received(:perform_async)
      end
    end
  end
end
