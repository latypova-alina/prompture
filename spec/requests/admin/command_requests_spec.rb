require "rails_helper"

describe "Admin command requests" do
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

  let(:user) { create(:user, :with_balance, name: "Rihanna") }
  let!(:image_command) { create(:command_prompt_to_image_request, user:) }
  let!(:audio_command) { create(:command_prompt_to_audio_request, user:) }

  describe "GET /users/:user_id/command_requests" do
    it "requires authentication" do
      get "/users/#{user.id}/command_requests"

      expect(response).to have_http_status(:unauthorized)
    end

    it "lists the user's command requests" do
      get "/users/#{user.id}/command_requests", headers: auth_headers

      expect(response.body).to include("#{image_command.class.name} ##{image_command.id}")
      expect(response.body).to include("#{audio_command.class.name} ##{audio_command.id}")
    end

    it "filters by type" do
      get "/users/#{user.id}/command_requests", params: { type: "CommandPromptToAudioRequest" }, headers: auth_headers

      expect(response.body).to include("#{audio_command.class.name} ##{audio_command.id}")
      expect(response.body).not_to include("#{image_command.class.name} ##{image_command.id}")
    end

    it "paginates results" do
      create_list(:command_prompt_to_image_request, 20, user:)

      get "/users/#{user.id}/command_requests", headers: auth_headers

      expect(response.body).to include("Page 1 of 2")
    end
  end
end
