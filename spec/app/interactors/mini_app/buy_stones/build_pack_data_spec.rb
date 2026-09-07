require "rails_helper"

describe MiniApp::BuyStones::BuildPackData do
  subject(:result) { described_class.call(user:, locale:) }

  let(:locale) { "en" }
  let(:invoice_url) { "https://t.me/$test" }

  before do
    allow(StarsPayment::InvoiceBuilder).to receive(:new).and_return(double(invoice_url:))
  end

  describe "#call" do
    context "when the user has not accepted the terms" do
      let(:user) { create(:user) }

      it "reports terms_required as true" do
        expect(result.terms_required).to eq(true)
      end

      it "does not include invoice urls" do
        expect(result.packs).to all(include(invoice_url: nil))
      end

      it "does not call StarsPayment::InvoiceBuilder" do
        result

        expect(StarsPayment::InvoiceBuilder).not_to have_received(:new)
      end
    end

    context "when the user has accepted the terms" do
      let(:user) { create(:user, :terms_accepted) }

      it "reports terms_required as false" do
        expect(result.terms_required).to eq(false)
      end

      it "includes invoice urls" do
        expect(result.packs).to all(include(invoice_url:))
      end

      it "includes the localized buy button text" do
        expect(result.buy_button).to eq(I18n.t("mini_app.buy_stones.buy_button", locale: "en"))
      end

      it "returns a pack for each configured pack" do
        expect(result.packs.map { |p| p[:key] }).to match_array(CREDIT_PACKS.keys)
      end
    end

    context "when the user's latest acceptance is for outdated policy versions" do
      let(:user) { create(:user) }

      before do
        create(:policy_acceptance, user:, privacy_policy_version: "2020-01-01", terms_version: "2020-01-01")
      end

      it "reports terms_required as true" do
        expect(result.terms_required).to eq(true)
      end

      it "does not include invoice urls" do
        expect(result.packs).to all(include(invoice_url: nil))
      end
    end

    context "when the user is an admin" do
      let(:user) { create(:user, :terms_accepted, admin: true) }

      it "returns the test packs" do
        expect(result.packs.map { |p| p[:key] }).to match_array(TEST_CREDIT_PACKS.keys)
      end
    end
  end
end
