require "rails_helper"

describe TermsGate::FindUser do
  subject(:result) { described_class.call(chat_id:) }

  let(:user) { create(:user) }
  let(:chat_id) { user.chat_id }

  it "resolves the user by chat_id" do
    expect(result.user).to eq(user)
  end

  it "marks terms as accepted for downstream steps" do
    expect(result.terms_accepted).to eq(true)
  end
end
