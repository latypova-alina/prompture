require "rails_helper"

describe MediaGenerator::MessageHandler::ImageMessageHandler::EnqueueStoreImageJob do
  subject(:result) { described_class.call(image_url_message:, picture_message:, file_message:) }

  let(:image_url_message) { nil }
  let(:picture_message) { nil }
  let(:file_message) { nil }

  before do
    allow(StoreImage::Job).to receive(:perform_async)
  end

  describe "#call" do
    context "when image_url_message is present" do
      let(:image_url_message) { create(:user_image_url_message) }

      it "sets image_record in context" do
        expect(result.image_record).to eq(image_url_message)
      end

      it "enqueues StoreImage::Job for image_url_message" do
        result

        expect(StoreImage::Job).to have_received(:perform_async).with(
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

      it "enqueues StoreImage::Job for picture_message" do
        result

        expect(StoreImage::Job).to have_received(:perform_async).with(
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

      it "enqueues StoreImage::Job for image_url_message" do
        result

        expect(StoreImage::Job).to have_received(:perform_async).with(
          image_url_message.class.name,
          image_url_message.id
        )
      end
    end

    context "when both image_url_message and picture_message are nil" do
      it "raises an error" do
        expect { result }.to raise_error(StandardError, "Image record is nil")
      end

      it "does not enqueue StoreImage::Job" do
        expect { result }.to raise_error(StandardError, "Image record is nil")
        expect(StoreImage::Job).not_to have_received(:perform_async)
      end
    end

    context "when only file_message is present" do
      let(:command_request) { create(:command_image_to_video_request) }
      let(:file_message) do
        UserFileMessage.create!(
          file_id: "BQACAgIAAxkBAAIHp...",
          size: 1.megabyte,
          tg_message_id: 123_456,
          parent_request: command_request,
          command_request:
        )
      end

      it "sets image_record in context" do
        expect(result.image_record).to eq(file_message)
      end

      it "enqueues StoreImage::Job for file_message" do
        result

        expect(StoreImage::Job).to have_received(:perform_async).with(
          file_message.class.name,
          file_message.id
        )
      end
    end
  end
end
