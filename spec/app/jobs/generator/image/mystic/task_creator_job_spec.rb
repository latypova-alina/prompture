require "rails_helper"

describe Generator::Image::Mystic::TaskCreatorJob do
  let(:prompt) { "little kitten" }
  let(:button_request) { "mystic_image" }
  let(:chat_id) { 123 }
  let(:task_id) { "mystic-task-456" }
  let(:token) { "encoded-token" }

  before do
    allow(ChatToken).to receive(:encode).with(chat_id).and_return(token)
    allow(Generator::Image::ErrorNotifierJob).to receive(:perform_async)
  end

  subject { described_class.new.perform(prompt, button_request, chat_id) }

  describe "#perform" do
    context "when the API response is successful" do
      include_context "stub create mystic task success request"

      it "does not call the error notifier job" do
        subject

        expect(Generator::Image::ErrorNotifierJob).not_to have_received(:perform_async)
      end
    end

    context "when the API response is NOT successful" do
      include_context "stub create mystic task fail request"

      it "rescues and calls the error notifier job" do
        subject

        expect(Generator::Image::ErrorNotifierJob).to have_received(:perform_async)
          .with(chat_id)
      end
    end
  end
end
