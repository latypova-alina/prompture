RSpec.shared_examples "a video callback" do |processor:, record_creator:, job_class:|
  include_context "telegram callback setup"

  let(:button_request_text) { "#{processor}_image_to_video" }
  let(:command) { "prompt_to_video" }

  context "when command is present" do
    let(:prompt_message) { create(:prompt_message, prompt: "cute white kitten") }

    let(:command_request) do
      create(:command_prompt_to_video_request,
             chat_id:)
    end

    let(:parent_request) do
      create(:button_image_processing_request, command_request:,
                                               parent_request: prompt_message)
    end

    let(:button_video_processing_request) do
      create(
        :button_video_processing_request,
        processor: button_request_text,
        command_request:,
        parent_request:
      )
    end

    let!(:user) { create(:user, :with_balance, chat_id: 456) }
    let!(:balance_transaction) { create(:balance_transaction, user:, source: button_video_processing_request) }

    before do
      setup_parent_message

      allow_any_instance_of(record_creator)
        .to receive(:record)
        .and_return(button_video_processing_request)
    end

    it "enqueues the video generation job" do
      expect(job_class).to receive(:perform_async)
        .with(
          "cute white kitten",
          nil,
          chat_id,
          button_request_text,
          button_video_processing_request.id
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
