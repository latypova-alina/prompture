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

    it "does not show the user search filter" do
      get "/users/#{user.id}/command_requests", headers: auth_headers

      expect(response.body).not_to include('name="user"')
    end
  end

  describe "GET /command_requests (global)" do
    it "requires authentication" do
      get "/command_requests"

      expect(response).to have_http_status(:unauthorized)
    end

    it "lists command requests across all users, with a User column" do
      other_user = create(:user, :with_balance, name: "Beyonce")
      other_command = create(:command_prompt_to_image_request, user: other_user)

      get "/command_requests", headers: auth_headers

      expect(response.body).to include("#{image_command.class.name} ##{image_command.id}")
      expect(response.body).to include("#{other_command.class.name} ##{other_command.id}")
      expect(response.body).to include("Rihanna").and include("Beyonce")
    end

    it "filters by user search" do
      other_user = create(:user, :with_balance, name: "Beyonce")
      other_command = create(:command_prompt_to_image_request, user: other_user)

      get "/command_requests", params: { user: "Rihanna" }, headers: auth_headers

      expect(response.body).to include("#{image_command.class.name} ##{image_command.id}")
      expect(response.body).not_to include("#{other_command.class.name} ##{other_command.id}")
    end

    it "filters by has_button_requests" do
      create(:button_image_processing_request, :completed, command_request: image_command,
                                                           parent_request: image_command)

      get "/command_requests", params: { has_button_requests: "with" }, headers: auth_headers

      expect(response.body).to include("#{image_command.class.name} ##{image_command.id}")
      expect(response.body).not_to include("#{audio_command.class.name} ##{audio_command.id}")
    end
  end
end
