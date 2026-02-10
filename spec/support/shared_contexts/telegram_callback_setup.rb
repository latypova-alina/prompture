RSpec.shared_context "telegram callback setup" do
  let(:session) { FakeSession.new }
  let(:chat_id) { 456 }
  let(:command) { "prompt_to_image" }

  let(:callback_query_data) do
    {
      "callback_query" => {
        "message" => {
          "entities" => [],
          "message_id" => message_id
        }
      }
    }
  end

  let(:message_id) { 789 }

  let(:command_request) do
    create(:command_prompt_to_image_request,
           chat_id:)
  end

  let(:parent_request) { create(:prompt_message, prompt: "cute white kitten") }

  before do
    setup_session
    setup_chat_info
    setup_callback_data
  end

  def setup_session
    allow_any_instance_of(described_class)
      .to receive(:session)
      .and_return(session)

    session[:command] = command
  end

  def setup_chat_info
    allow_any_instance_of(described_class)
      .to receive(:chat)
      .and_return({ "id" => chat_id })
  end

  def setup_callback_data
    allow_any_instance_of(described_class)
      .to receive(:update)
      .and_return(callback_query_data)
  end

  def setup_parent_message
    create(
      :telegram_message,
      tg_message_id: message_id,
      chat_id: chat_id,
      request: parent_request
    )
  end
end
