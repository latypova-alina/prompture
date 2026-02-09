RSpec.shared_examples "video task creator job" do |processor:|
  let(:prompt) { "little kitten" }
  let(:button_request) { "#{processor}_image_to_video" }
  let(:chat_id) { 123 }
  let(:task_id) { "#{processor}-task-456" }
  let(:token) { "encoded-token" }
  let(:image_url) { "http://example.com/image.jpg" }
  let(:command_request) { create(:command_prompt_to_video_request) }
  let(:button_request_record) do
    create(:button_video_processing_request, parent_request: command_request, command_request:)
  end
  let(:request_id) { button_request_record.id }

  before do
    allow(ChatToken).to receive(:encode).with(chat_id).and_return(token)
    allow(Generator::Video::ErrorNotifierJob).to receive(:perform_async)
  end

  subject { described_class.new.perform(prompt, image_url, chat_id, button_request, request_id) }

  describe "#perform" do
    context "when the API response is successful" do
      include_context "stub create #{processor} task success request"

      it "does not call the error notifier job" do
        subject

        expect(Generator::Video::ErrorNotifierJob).not_to have_received(:perform_async)
      end
    end

    context "when the API response is NOT successful" do
      include_context "stub create #{processor} task fail request"

      it "rescues and calls the error notifier job" do
        subject

        expect(Generator::Video::ErrorNotifierJob).to have_received(:perform_async)
          .with(chat_id)
      end
    end
  end
end
