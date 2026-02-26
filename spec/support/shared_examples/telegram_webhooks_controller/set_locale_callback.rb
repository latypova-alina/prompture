RSpec.shared_examples "set_locale callback" do
  include_context "telegram callback setup"

  let(:button_request_text) { "set_locale:es" }

  let!(:user) { create(:user, :with_balance, chat_id: 456, locale: "en") }

  it "changes the users locale" do
    expect do
      described_class.new.callback_query(button_request_text)
    end.to change { user.reload.locale }.to("es")
  end
end
