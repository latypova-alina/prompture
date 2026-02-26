require "rails_helper"

describe SetLocale::ButtonHandler::UpdateUser do
  subject(:result) { described_class.call(chat_id:, selected_locale:) }

  let(:chat_id) { 456 }
  let(:selected_locale) { "es" }

  describe ".call" do
    context "when user exists" do
      let!(:user) { create(:user, chat_id:, locale: "en") }

      it "updates user locale" do
        expect { result }
          .to change { user.reload.locale }
          .from("en")
          .to("es")
      end

      it "returns success" do
        expect(result).to be_success
      end
    end

    context "when user does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect { result }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
