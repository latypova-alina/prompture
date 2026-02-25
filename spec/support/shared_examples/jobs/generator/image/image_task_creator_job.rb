RSpec.shared_examples "image task creator job" do |processor:|
  let(:prompt) { "little kitten" }
  let(:button_request) { "#{processor}_image" }
  let(:chat_id) { 123 }
  let(:task_id) { "#{processor}-task-456" }
  let(:token) { "encoded-token" }
  let(:request_id) { button_request_record.id }
  let!(:user) { create(:user, chat_id:) }
  let(:button_request_record) do
    create(:button_image_processing_request, :belonging_to_user, user:, processor: button_request)
  end

  before do
    allow(ChatToken).to receive(:encode).with(chat_id).and_return(token)
    allow(Generator::Image::ErrorNotifierJob).to receive(:perform_async)
  end

  subject { described_class.new.perform(prompt, chat_id, button_request, request_id) }

  describe "#perform" do
    context "when the API response is successful" do
      include_context "stub create #{processor} task success request"

      it "does not call the error notifier job" do
        subject

        expect(Generator::Image::ErrorNotifierJob).not_to have_received(:perform_async)
      end
    end

    context "when the API response is NOT successful" do
      include_context "stub create #{processor} task fail request"

      before do
        allow(Billing::Refunder).to receive(:call).with(user:, amount: button_request_record.cost,
                                                        source: button_request_record)
      end

      it "rescues and calls the error notifier job" do
        subject

        expect(Generator::Image::ErrorNotifierJob).to have_received(:perform_async)
          .with(chat_id, "en")
        expect(Billing::Refunder).to have_received(:call).with(user:, amount: button_request_record.cost,
                                                               source: button_request_record)
      end
    end
  end
end
