RSpec.shared_examples "command handling" do |command:|
  subject { -> { dispatch_command command } }

  let!(:user) { create(:user, :with_balance, chat_id: 456) }

  it { is_expected.to respond_with_message(expected_text) }

  context "when chat is not allowed" do
    let(:chat_id) { 999 }

    it { is_expected.to respond_with_message("Seems you need to activate a token first 🔑") }
  end
end
