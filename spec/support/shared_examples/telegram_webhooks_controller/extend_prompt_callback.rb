RSpec.shared_examples "extend prompt callback" do |record_creator:, job_class:|
  let(:button_request_text) { "extend_prompt" }

  include_context "telegram callback setup"

  context "when command is present" do
    let(:button_request) do
      create(
        :button_extend_prompt_request,
        prompt: "cute white kitten extended"
      )
    end

    let!(:user) { create(:user, :with_balance, chat_id: 456) }

    before do
      setup_parent_message

      ButtonExtendPromptRequest.delete_all

      allow_any_instance_of(record_creator)
        .to receive(:record)
        .and_return(button_request)
    end

    it "enqueues the image generation job" do
      expect(job_class).to receive(:perform_async)
        .with(
          "cute white kitten",
          chat_id,
          button_request.id
        )

      described_class.new.callback_query(button_request_text)
    end
  end
end
