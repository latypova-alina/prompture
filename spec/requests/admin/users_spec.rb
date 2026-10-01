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
end
