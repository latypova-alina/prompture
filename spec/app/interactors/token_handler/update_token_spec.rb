require "rails_helper"

describe TokenHandler::UpdateToken do
  subject { described_class.call(token:, user:) }

  let(:user) { create(:user) }
  let(:token) { create(:token, used_at: nil, user: nil) }

  describe "#call" do
    it "updates token used_at" do
      freeze_time do
        subject

        expect(token.reload.used_at).to eq(Date.current)
      end
    end

    it "assigns the user to the token" do
      subject

      expect(token.reload.user).to eq(user)
    end

    it "is successful" do
      expect(subject).to be_success
    end
  end
end
