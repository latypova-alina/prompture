require "rails_helper"

describe "Mini app framing" do
  subject { response.headers }

  let(:host) { "www.example.com" }
  let(:headers) { {} }
  let(:frame_ancestors) { "frame-ancestors 'self' https://web.telegram.org" }

  before do
    stub_const("ENV", ENV.to_hash.merge("ADMIN_USERNAME" => "admin", "ADMIN_PASSWORD" => "secret"))
    host! host
    get path, headers:
  end

  context "when opening the store mini app" do
    let(:path) { "/mini_app/buy_stones" }

    it { is_expected.not_to have_key("X-Frame-Options") }
    it { expect(response.headers["Content-Security-Policy"]).to include(frame_ancestors) }
  end

  context "when opening the review mini app" do
    let(:path) { "/mini_app/review" }

    it { is_expected.not_to have_key("X-Frame-Options") }
    it { expect(response.headers["Content-Security-Policy"]).to include(frame_ancestors) }
  end

  context "when opening the admin panel" do
    let(:host) { "admin.caivemanator.com" }
    let(:path) { "/" }
    let(:headers) do
      { "HTTP_AUTHORIZATION" => ActionController::HttpAuthentication::Basic.encode_credentials("admin", "secret") }
    end

    it { expect(response.headers["X-Frame-Options"]).to eq("SAMEORIGIN") }
    it { is_expected.not_to have_key("Content-Security-Policy") }
  end
end
