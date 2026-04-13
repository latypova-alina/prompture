require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::EnqueueStoreImageJob do
  subject(:result) { described_class.call(image_url_message:, picture_message:) }

  let(:image_url_message) { nil }
  let(:picture_message) { nil }

  before do
    allow(StoreImageJob).to receive(:perform_async)
  end

  describe "#call" do
    context "when image_url_message is present" do
      let(:image_url_message) { create(:user_image_url_message) }

      it "sets image_record in context" do
        expect(result.image_record).to eq(image_url_message)
      end

      it "enqueues StoreImageJob for image_url_message" do
        result

        expect(StoreImageJob).to have_received(:perform_async).with(
          image_url_message.class.name,
          image_url_message.id
        )
      end
    end

    context "when image_url_message is nil and picture_message is present" do
      let(:picture_message) { create(:user_picture_message) }

      it "sets image_record in context" do
        expect(result.image_record).to eq(picture_message)
      end

      it "enqueues StoreImageJob for picture_message" do
        result

        expect(StoreImageJob).to have_received(:perform_async).with(
          picture_message.class.name,
          picture_message.id
        )
      end
    end

    context "when both image_url_message and picture_message are present" do
      let(:image_url_message) { create(:user_image_url_message) }
      let(:picture_message) { create(:user_picture_message) }

      it "prefers image_url_message for image_record" do
        expect(result.image_record).to eq(image_url_message)
      end

      it "enqueues StoreImageJob for image_url_message" do
        result

        expect(StoreImageJob).to have_received(:perform_async).with(
          image_url_message.class.name,
          image_url_message.id
        )
      end
    end

    context "when both image_url_message and picture_message are nil" do
      it "sets image_record to nil in context" do
        expect(result.image_record).to be_nil
      end

      it "does not enqueue StoreImageJob" do
        result

        expect(StoreImageJob).not_to have_received(:perform_async)
      end
    end
  end
end
