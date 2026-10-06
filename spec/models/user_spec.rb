require "rails_helper"

describe User do
  describe "deleting a user" do
    subject(:destroy) { user.destroy }

    let(:user) { create(:user, chat_id: 456) }

    before do
      create(:chat_event, user:, chat_id: 456)
      create(:chat_event, user: nil, chat_id: 456)
      create(:chat_event, user: nil, chat_id: 789)
    end

    it "removes their chat history, including events recorded before they had an account" do
      destroy

      expect(ChatEvent.pluck(:chat_id)).to eq([789])
    end
  end
end
