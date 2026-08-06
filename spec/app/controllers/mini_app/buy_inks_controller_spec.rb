require "rails_helper"

describe MiniApp::BuyInksController, type: :request do
  describe "#show" do
    subject(:make_request) { get "/mini_app/buy_inks" }

    it "returns http success" do
      make_request

      expect(response).to have_http_status(:ok)
    end

    it "renders a shell that calls the packs endpoint" do
      make_request

      expect(response.body).to include('fetch("/mini_app/buy_inks/packs"')
      expect(response.body).not_to include("&quot;")
    end
  end

  describe "#packs" do
    subject(:make_request) do
      post "/mini_app/buy_inks/packs",
           params: { init_data: }.to_json,
           headers: { "Content-Type" => "application/json" }
    end

    let(:bot_token) { "test-bot-token" }
    let(:bot) { instance_double(Telegram::Bot::Client) }
    let(:telegram_user_id) { 110_542_578 }

    let(:signed_params) do
      { "auth_date" => "1700000000", "user" => { id: telegram_user_id, first_name: "Alina" }.to_json }
    end

    let(:init_data) do
      data_check_string = signed_params.sort.map { |key, value| "#{key}=#{value}" }.join("\n")
      secret_key = OpenSSL::HMAC.digest("SHA256", "WebAppData", bot_token)
      hash = OpenSSL::HMAC.hexdigest("SHA256", secret_key, data_check_string)

      URI.encode_www_form(signed_params.merge("hash" => hash))
    end

    before do
      stub_const("ENV", ENV.to_hash.merge("TELEGRAM_BOT_TOKEN" => bot_token))
      allow(Telegram).to receive(:bot).and_return(bot)
      allow(bot).to receive(:create_invoice_link).and_return({ "ok" => true, "result" => "https://t.me/$test" })
    end

    context "when init_data is valid and the user already exists" do
      let!(:user) { create(:user, chat_id: telegram_user_id, locale: "ru") }

      it "returns http success" do
        make_request

        expect(response).to have_http_status(:ok)
      end

      it "returns a pack for each configured pack, each with an invoice url" do
        make_request

        body = JSON.parse(response.body)

        expect(body["packs"].map { |p| p["key"] }).to match_array(CREDIT_PACKS.keys.map(&:to_s))
        expect(body["packs"]).to all(include("invoice_url" => "https://t.me/$test"))
      end

      it "localizes the pack titles and buy button using the user's stored locale" do
        make_request

        body = JSON.parse(response.body)

        expect(body["buy_button"]).to eq(I18n.t("mini_app.buy_inks.buy_button", locale: "ru"))
        small_pack = body["packs"].find { |p| p["key"] == "small" }
        expected_title = I18n.t("telegram_webhooks.commands.buy_inks.pack_title.small", locale: "ru")
        expect(small_pack["title"]).to eq(expected_title)
      end

      it "does not change the existing user's locale" do
        expect { make_request }.not_to(change { user.reload.locale })
      end
    end

    context "when the user is an admin" do
      let!(:user) { create(:user, chat_id: telegram_user_id, locale: "en", admin: true) }

      it "returns the test packs, all priced at 1 star" do
        make_request

        body = JSON.parse(response.body)

        expect(body["packs"].map { |p| p["key"] }).to match_array(TEST_CREDIT_PACKS.keys.map(&:to_s))
        expect(body["packs"]).to all(include("stars" => 1))
      end
    end

    context "when the existing user has an unsupported locale" do
      let!(:user) { create(:user, chat_id: telegram_user_id, locale: "de") }

      it "falls back to the default locale for the buy button" do
        make_request

        body = JSON.parse(response.body)

        expect(body["buy_button"]).to eq(I18n.t("mini_app.buy_inks.buy_button", locale: I18n.default_locale))
      end
    end

    context "when init_data is valid but the user does not exist yet" do
      it "auto-creates the user" do
        expect { make_request }.to change(User, :count).by(1)

        created_user = User.find_by(chat_id: telegram_user_id)
        expect(created_user).to have_attributes(name: "Alina", locale: I18n.default_locale.to_s)
      end

      it "returns http success" do
        make_request

        expect(response).to have_http_status(:ok)
      end
    end

    context "when init_data is invalid" do
      let(:init_data) { "hash=deadbeef&user=%7B%22id%22%3A1%7D" }

      it "returns unauthorized" do
        make_request

        expect(response).to have_http_status(:unauthorized)
      end

      it "does not create a user" do
        expect { make_request }.not_to change(User, :count)
      end
    end
  end
end
