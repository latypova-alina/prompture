require "rails_helper"

describe TokenHandler::FindOrCreateUser do
  subject(:result) { described_class.call(chat_id:, name:, locale:) }

  let(:chat_id) { 456 }
  let(:name) { "Barbara" }
  let(:locale) { "en" }
  let(:user) { create(:user, chat_id:) }

  before do
    allow(UserResolver).to receive(:new).with(chat_id:, name:, locale:).and_return(instance_double(UserResolver, user:))
  end

  describe "#call" do
    it "assigns the resolved user to context" do
      expect(result.user).to eq(user)
    end

    it "is successful" do
      expect(result).to be_success
    end
  end
end
