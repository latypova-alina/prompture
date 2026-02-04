RSpec.shared_examples "a video callback" do |processor:, record_creator:, job_class:|
  include_context "telegram callback setup"

  let(:button_request_text) { "#{processor}_image_to_video" }
  let(:command) { "prompt_to_video" }

  context "when command is present" do
    let(:command_request) do
      create(:command_prompt_to_video_request,
             prompt: "cute white kitten",
             chat_id:)
    end

    let(:parent_request) do
      create(:button_image_processing_request, image_url: "http://example.com/image.jpg", command_request:,
                                               parent_request: command_request)
    end

    let(:button_video_processing_request) do
      create(
        :button_video_processing_request,
        processor:,
        command_request:,
        parent_request:
      )
    end

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

  context "when command is missing" do
    let(:other_command_request) do
      create(:command_prompt_to_video_request,
             prompt: "other prompt",
             chat_id: 0)
    end
    let(:parent_request) do
      create(:button_extend_prompt_request, prompt: "cute white kitten", command_request: other_command_request,
                                            parent_request: other_command_request)
    end

    before { setup_parent_message }

    it "raises an error" do
      expect do
        described_class.new.callback_query(button_request_text)
      end.to raise_error(CommandRequestForgottenError)
    end
  end
end
