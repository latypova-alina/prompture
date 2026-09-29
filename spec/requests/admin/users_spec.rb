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
  end

  describe "GET /users/:id" do
    let(:user) { create(:user, :with_balance, name: "Rihanna") }
    let!(:command_request) { create(:command_prompt_to_image_request, user:) }
    let!(:button_request) { create(:button_image_processing_request, :completed, command_request:) }

    it "requires authentication" do
      get "/users/#{user.id}"

      expect(response).to have_http_status(:unauthorized)
    end

    it "shows the user's generation history" do
      get "/users/#{user.id}", headers: auth_headers

      expect(response.body).to include("Rihanna")
      expect(response.body).to include(command_request.class.name)
      expect(response.body).to include(button_request.humanized_process_name)
    end
  end
end
