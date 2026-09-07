require "rails_helper"

describe MiniApp::BuyStones::ResolveUser do
  subject(:result) { described_class.call(init_data:) }

  let(:telegram_user_id) { 110_542_578 }
  let(:init_data) { URI.encode_www_form("user" => { id: telegram_user_id, first_name: "Alina" }.to_json) }

  describe "#call" do
    context "when the user does not exist yet" do
      it "creates a user with the default locale" do
        expect { result }.to change(User, :count).by(1)

        created_user = User.find_by(chat_id: telegram_user_id)
        expect(created_user).to have_attributes(name: "Alina", locale: I18n.default_locale.to_s)
      end

      it "assigns the created user and locale to context" do
        expect(result.user).to eq(User.find_by(chat_id: telegram_user_id))
        expect(result.locale).to eq(I18n.default_locale.to_s)
      end
    end

    context "when the user already exists with a supported locale" do
      let!(:user) { create(:user, chat_id: telegram_user_id, locale: "ru") }

      it "does not create a new user" do
        expect { result }.not_to change(User, :count)
      end

      it "assigns the existing user and their locale to context" do
        expect(result.user).to eq(user)
        expect(result.locale).to eq("ru")
      end
    end

    context "when the existing user has an unsupported locale" do
      let!(:user) { create(:user, chat_id: telegram_user_id, locale: "de") }

      it "falls back to the default locale" do
        expect(result.locale).to eq(I18n.default_locale.to_s)
      end
    end
  end
end
