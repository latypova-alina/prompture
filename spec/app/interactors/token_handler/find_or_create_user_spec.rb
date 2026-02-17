require "rails_helper"

describe TokenHandler::FindOrCreateUser do
  subject { described_class.call(chat_id:, name:) }

  let(:chat_id) { 456 }
  let(:name) { "Barbara" }

  describe "#call" do
    context "when user already exists" do
      let!(:existing_user) { create(:user, chat_id:, name: "Existing Barbara") }

      it "does not create a new user" do
        expect { subject }.not_to change(User, :count)
      end

      it "returns the existing user in context" do
        expect(subject.user).to eq(existing_user)
      end

      it "does not update the name" do
        subject
        expect(existing_user.reload.name).to eq("Existing Barbara")
      end
    end

    context "when user does not exist" do
      it "creates a new user" do
        expect { subject }.to change(User, :count).by(1)
      end

      it "sets the provided name" do
        result = subject

        expect(result.user.name).to eq("Barbara")
        expect(result.user.chat_id).to eq(chat_id)
      end
    end

    context "when name is nil" do
      let(:name) { nil }

      it "creates user with fallback name" do
        result = subject

        expect(result.user.name).to eq("User#{chat_id}")
      end
    end
  end
end
