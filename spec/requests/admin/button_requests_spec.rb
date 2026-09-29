require "rails_helper"

describe "Admin button requests" do
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
  let(:command) { create(:command_prompt_to_image_request, user:) }
  let!(:image_request) { create(:button_image_processing_request, :completed, command_request: command) }
  let!(:extend_prompt_request) { create(:button_extend_prompt_request, command_request: command) }

  describe "GET /users/:user_id/button_requests" do
    it "requires authentication" do
      get "/users/#{user.id}/button_requests"

      expect(response).to have_http_status(:unauthorized)
    end

    it "lists the user's button requests" do
      get "/users/#{user.id}/button_requests", headers: auth_headers

      expect(response.body).to include(image_request.humanized_process_name)
      expect(response.body).to include(extend_prompt_request.humanized_process_name)
    end

    it "filters by type" do
      get "/users/#{user.id}/button_requests",
          params: { type: "ButtonExtendPromptRequest" }, headers: auth_headers

      expect(response.body).to include(extend_prompt_request.humanized_process_name)
      expect(response.body).not_to include(image_request.humanized_process_name)
    end

    it "paginates results" do
      create_list(:button_image_processing_request, 20, :completed, command_request: command)

      get "/users/#{user.id}/button_requests", headers: auth_headers

      expect(response.body).to include("Page 1 of 2")
    end

    it "does not N+1 query command_request, user, or stored media across rows" do
      create(:stored_image, source_message: image_request)
      other_image_command = create(:command_prompt_to_image_request, user:)
      other_image_request = create(:button_image_processing_request, :completed, command_request: other_image_command)
      create(:stored_image, source_message: other_image_request)
      video_command = create(:command_prompt_to_video_request, user:)
      video_request = create(:button_video_processing_request, command_request: video_command)
      create(:stored_video, source: video_request)

      get "/users/#{user.id}/button_requests", headers: auth_headers

      expect(response).to have_http_status(:ok)
    end
  end
end
