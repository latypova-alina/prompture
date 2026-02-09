RSpec.shared_examples "command handling" do |command:|
  subject { -> { dispatch_command command } }

  it { is_expected.to respond_with_message(expected_text) }

  context "when chat is not allowed" do
    let(:chat_id) { 999 }

    it { is_expected.to respond_with_message("Sorry, you are not authorized to use this bot.") }
  end
end
