RSpec.shared_examples "an image callback" do |processor:, record_creator:, job_class:|
  let(:button_request_text) { "#{processor}_image" }
  include_context "telegram callback setup"

  context "when command is present" do
    let(:parent_request) do
      create(:button_extend_prompt_request, prompt: "cute white kitten extended", command_request:,
                                            parent_request: command_request)
    end

    let!(:user) { create(:user, :with_balance, chat_id: 456) }
    let!(:balance_transaction) { create(:balance_transaction, user:, source: button_image_processing_request) }

    let(:button_image_processing_request) do
      create(
        :button_image_processing_request,
        processor: button_request_text,
        command_request:,
        parent_request:
      )
    end

    before do
      setup_parent_message

      allow_any_instance_of(record_creator)
        .to receive(:record)
        .and_return(button_image_processing_request)
    end

    it "enqueues the image generation job" do
      expect(job_class).to receive(:perform_async)
        .with(
          "cute white kitten extended",
          chat_id,
          button_request_text,
          button_image_processing_request.id
        )

      described_class.new.callback_query(button_request_text)
    end
  end

  context "when parent is missing" do
    let(:parent_request) { nil }

    it "raises an error" do
      expect do
        described_class.new.callback_query(button_request_text)
      end.to raise_error(ParentNotFoundError)
    end
  end
end
