require "rails_helper"

describe UserResolver do
  subject(:user) { described_class.new(chat_id:, name:, locale: "en").user }

  let(:chat_id) { 456 }
  let(:name) { "Barbara" }

  describe "#user" do
    context "when user already exists" do
      let!(:existing_user) { create(:user, chat_id:, name: "Existing Barbara") }

      it "does not create a new user" do
        expect { user }.not_to change(User, :count)
      end

      it "returns the existing user" do
        expect(user).to eq(existing_user)
      end

      it "does not update the name" do
        user
        expect(existing_user.reload.name).to eq("Existing Barbara")
      end
    end

    context "when user does not exist" do
      it "creates a new user" do
        expect { user }.to change(User, :count).by(1)
      end

      it "sets the provided name" do
        expect(user.name).to eq("Barbara")
        expect(user.chat_id).to eq(chat_id)
      end
    end

    context "when name is nil" do
      let(:name) { nil }

      it "creates user with fallback name" do
        expect(user.name).to eq("User#{chat_id}")
      end
    end
  end
end
