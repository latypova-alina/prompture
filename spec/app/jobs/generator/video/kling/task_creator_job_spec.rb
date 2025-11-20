require "rails_helper"

describe Generator::Video::Kling::TaskCreatorJob do
  let(:prompt) { "little kitten" }
  let(:button_request) { "kling_2_1_pro_image_to_video" }
  let(:chat_id) { 123 }
  let(:task_id) { "kling-task-456" }
  let(:token) { "encoded-token" }
  let(:image_url) { "http://example.com/image.jpg" }

  before do
    allow(ChatToken).to receive(:encode).with(chat_id).and_return(token)
    allow(Generator::Video::ErrorNotifierJob).to receive(:perform_async)
  end

  subject { described_class.new.perform(prompt, image_url, button_request, chat_id) }

  describe "#perform" do
    context "when the API response is successful" do
      include_context "stub create kling task success request"

      it "does not call the error notifier job" do
        subject

        expect(Generator::Video::ErrorNotifierJob).not_to have_received(:perform_async)
      end
    end

    context "when the API response is NOT successful" do
      include_context "stub create kling task fail request"

      it "rescues and calls the error notifier job" do
        subject

        expect(Generator::Video::ErrorNotifierJob).to have_received(:perform_async)
          .with(chat_id)
      end
    end
  end
end
