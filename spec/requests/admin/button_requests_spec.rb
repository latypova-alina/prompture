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
  let!(:image_request) do
    create(:button_image_processing_request, :completed, command_request: command, created_at: 2.days.ago)
  end
  let!(:extend_prompt_request) do
    create(:button_extend_prompt_request, command_request: command, created_at: 1.day.ago)
  end

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

    it "shows each button request's class name and id" do
      get "/users/#{user.id}/button_requests", headers: auth_headers

      expect(response.body).to include("ButtonImageProcessingRequest##{image_request.id}")
      expect(response.body).to include(%(href="/button_requests/image_processing/#{image_request.id}"))
      expect(response.body).to include(%(href="/command_requests/prompt_to_image/#{image_request.command_request_id}"))
    end

    it "filters by type" do
      get "/users/#{user.id}/button_requests",
          params: { type: "ButtonExtendPromptRequest" }, headers: auth_headers

      expect(response.body).to include(extend_prompt_request.humanized_process_name)
      expect(response.body).not_to include(image_request.humanized_process_name)
    end

    it "filters by status" do
      get "/users/#{user.id}/button_requests", params: { status: "COMPLETED" }, headers: auth_headers

      expect(response.body).to include(image_request.created_at.to_s)
      expect(response.body).not_to include(extend_prompt_request.created_at.to_s)
    end

    it "does not error when status is given as an array" do
      get "/users/#{user.id}/button_requests", params: { status: %w[x y] }, headers: auth_headers

      expect(response).to have_http_status(:ok)
    end

    it "filters by processor" do
      get "/users/#{user.id}/button_requests", params: { processor: image_request.processor }, headers: auth_headers

      expect(response.body).to include(image_request.created_at.to_s)
      expect(response.body).not_to include(extend_prompt_request.created_at.to_s)
    end

    it "filters by command type" do
      audio_command = create(:command_prompt_to_audio_request, user:)
      audio_request = create(:button_audio_processing_request, command_request: audio_command)

      get "/users/#{user.id}/button_requests",
          params: { command_type: "CommandPromptToAudioRequest" }, headers: auth_headers

      expect(response.body).to include(audio_request.humanized_process_name)
      expect(response.body).not_to include(image_request.humanized_process_name)
    end

    it "renders the status, processor, and command type filter selects" do
      get "/users/#{user.id}/button_requests", headers: auth_headers

      expect(response.body).to include('name="status"')
      expect(response.body).to include('name="processor"')
      expect(response.body).to include('name="command_type"')
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

    it "does not show the user search filter" do
      get "/users/#{user.id}/button_requests", headers: auth_headers

      expect(response.body).not_to include('name="user"')
    end
  end

  describe "GET /button_requests (global)" do
    it "requires authentication" do
      get "/button_requests"

      expect(response).to have_http_status(:unauthorized)
    end

    it "lists button requests across all users, with a User column" do
      other_user = create(:user, :with_balance, name: "Beyonce")
      other_command = create(:command_prompt_to_image_request, user: other_user)
      other_request = create(:button_image_processing_request, :completed, command_request: other_command,
                                                                           parent_request: other_command)

      get "/button_requests", headers: auth_headers

      expect(response.body).to include(image_request.created_at.to_s)
      expect(response.body).to include(other_request.created_at.to_s)
      expect(response.body).to include("Rihanna").and include("Beyonce")
    end

    it "filters by user search" do
      other_user = create(:user, :with_balance, name: "Beyonce")
      other_command = create(:command_prompt_to_image_request, user: other_user)
      other_request = create(:button_image_processing_request, :completed, command_request: other_command,
                                                                           parent_request: other_command)

      get "/button_requests", params: { user: "Rihanna" }, headers: auth_headers

      expect(response.body).to include(image_request.created_at.to_s)
      expect(response.body).not_to include(other_request.created_at.to_s)
    end
  end
end
