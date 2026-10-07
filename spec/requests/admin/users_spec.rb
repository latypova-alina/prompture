require "rails_helper"

describe "Admin users" do
  before do
    ENV["ADMIN_USERNAME"] = "admin"
    ENV["ADMIN_PASSWORD"] = "secret"
    host! "admin.caivemanator.com"
  end

  after do
    ENV.delete("ADMIN_USERNAME")
    ENV.delete("ADMIN_PASSWORD")
  end

  let(:auth_headers) do
    { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "secret") }
  end

  describe "GET /users" do
    let!(:user) { create(:user, :with_balance, name: "Rihanna") }

    it "requires authentication" do
      get "/users"

      expect(response).to have_http_status(:unauthorized)
    end

    it "lists users" do
      get "/users", headers: auth_headers

      expect(response.body).to include("Rihanna")
    end

    it "shows each user's id" do
      get "/users", headers: auth_headers

      expect(response.body).to include("<td>#{user.id}</td>")
    end
  end

  describe "GET /users/:id" do
    let(:user) { create(:user, :with_balance, name: "Rihanna") }
    let!(:command_request) { create(:command_prompt_to_image_request, user:) }
    let!(:button_request) { create(:button_image_processing_request, :completed, command_request:) }

    it "requires authentication" do
      get "/users/#{user.id}"

      expect(response).to have_http_status(:unauthorized)
    end

    it "shows the user's generation history counts with links to the detail pages" do
      get "/users/#{user.id}", headers: auth_headers

      expect(response.body).to include("Rihanna")
      expect(response.body).to include("Command requests (1)")
      expect(response.body).to include("Button requests (1)")
      expect(response.body).to include("/users/#{user.id}/command_requests")
      expect(response.body).to include("/users/#{user.id}/button_requests")
    end
  end

  describe "blocked users" do
    let!(:blocked) { create(:user, name: "Zed", blocked_at: Time.zone.parse("2026-10-01 12:00")) }
    let!(:active) { create(:user, name: "Amy") }

    it "shows a badge on the user page" do
      get "/users/#{blocked.id}", headers: auth_headers

      expect(response.body).to include("Blocked the bot since October 01, 2026")
    end

    it "doesn't show the badge for a user who didn't block the bot" do
      get "/users/#{active.id}", headers: auth_headers

      expect(response.body).not_to include("Blocked the bot since")
    end

    it "marks blocked users in the list" do
      get "/users", headers: auth_headers

      expect(response.body).to include("badge-blocked")
    end

    it "filters to blocked users" do
      get "/users", params: { blocked: "blocked" }, headers: auth_headers

      expect(response.body).to include(">Zed<")
      expect(response.body).not_to include(">Amy<")
    end

    it "filters to users who didn't block the bot" do
      get "/users", params: { blocked: "not_blocked" }, headers: auth_headers

      expect(response.body).to include(">Amy<")
      expect(response.body).not_to include(">Zed<")
    end
  end

  describe "sorting GET /users" do
    let!(:rich) { create(:user, name: "Zed").tap { |user| create(:balance, user:, credits: 900) } }
    let!(:poor) { create(:user, name: "Amy").tap { |user| create(:balance, user:, credits: 1) } }

    it "sorts by balance" do
      get "/users", params: { sort: "balance", direction: "desc" }, headers: auth_headers

      expect(response.body.index(">Zed<")).to be < response.body.index(">Amy<")
      expect(response.body).to include("Balance ▼")
    end

    it "sorts by name" do
      get "/users", params: { sort: "name" }, headers: auth_headers

      expect(response.body.index(">Amy<")).to be < response.body.index(">Zed<")
    end
  end

  describe "review on GET /users/:id" do
    subject { response.body }

    let(:user) { create(:user, :with_balance) }

    context "when the user left a review" do
      before do
        create(:review, user:)
        get "/users/#{user.id}", headers: auth_headers
      end

      it { is_expected.to include("What&#39;s missing in the bot?") }
      it { is_expected.to include("more voices for the audio feature") }
    end

    context "when there is no review" do
      before { get "/users/#{user.id}", headers: auth_headers }

      it { is_expected.to include("No review yet.") }
    end
  end
end
