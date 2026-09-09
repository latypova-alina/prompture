require "rails_helper"

describe "Admin subdomain" do
  before do
    ENV["ADMIN_USERNAME"] = "admin"
    ENV["ADMIN_PASSWORD"] = "secret"
    host! "admin.caivemanator.com"
  end

  after do
    ENV.delete("ADMIN_USERNAME")
    ENV.delete("ADMIN_PASSWORD")
  end

  it "requires authentication" do
    get "/"

    expect(response).to have_http_status(:unauthorized)
  end

  it "rejects wrong credentials" do
    get "/", headers: { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "wrong") }

    expect(response).to have_http_status(:unauthorized)
  end

  it "shows links to blazer and sidekiq with correct credentials" do
    get "/", headers: { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "secret") }

    expect(response.body).to include("/blazer").and include("/sidekiq")
  end

  it "does not protect other hosts" do
    host! "caivemanator.com"

    get "/"

    expect(response).to have_http_status(:not_found)
  end
end
