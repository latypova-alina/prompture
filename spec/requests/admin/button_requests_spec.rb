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

  describe "failure reason" do
    let!(:failed_request) do
      create(:button_image_processing_request, command_request: command, status: "FAILED",
                                               failure_reason: "insufficient_credits")
    end

    it "shows it next to the status in the list" do
      get "/users/#{user.id}/button_requests", headers: auth_headers

      expect(response.body).to include("Insufficient credits")
    end

    it "shows it on the request page" do
      get "/button_requests/image_processing/#{failed_request.id}", headers: auth_headers

      expect(response.body).to include("insufficient_credits")
    end
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

  describe "sorting" do
    def position(record)
      response.body.index("#{record.class.name}##{record.id}")
    end

    it "sorts newest first by default" do
      get "/users/#{user.id}/button_requests", headers: auth_headers

      expect(position(extend_prompt_request)).to be < position(image_request)
      expect(response.body).to include("Created ▼")
    end

    it "sorts by the clicked column" do
      get "/users/#{user.id}/button_requests", params: { sort: "status", direction: "asc" }, headers: auth_headers

      expect(position(image_request)).to be < position(extend_prompt_request)
      expect(response.body).to include("Status ▲")
    end

    it "keeps filters in header links and drops the page" do
      get "/users/#{user.id}/button_requests", params: { status: "COMPLETED", page: 1 }, headers: auth_headers

      expect(response.body).to include(
        "/users/#{user.id}/button_requests?direction=asc&amp;sort=cost&amp;status=COMPLETED"
      )
    end

    it "keeps sort and filters in pagination links and the filters form" do
      create_list(:button_image_processing_request, 20, :completed, command_request: command)

      get "/users/#{user.id}/button_requests", params: { status: "COMPLETED", sort: "cost", direction: "desc" },
                                               headers: auth_headers

      expect(response.body).to include("direction=desc&amp;page=2&amp;sort=cost&amp;status=COMPLETED")
      expect(response.body).to include('<input name="sort" type="hidden" value="cost" />')
    end
  end

  describe "fal column" do
    let(:audio_command) { create(:command_prompt_to_audio_request, user:) }

    let!(:fal_image) { create(:button_image_processing_request, command_request: command, fal_request_id: "img-1") }
    let!(:fal_video) do
      create(:button_video_processing_request, command_request: command, processor: "veo3_1_lite_image_to_video",
                                               fal_request_id: "vid-1")
    end
    let!(:fal_audio) do
      create(:button_audio_processing_request, command_request: audio_command, fal_request_id: "aud-1")
    end

    before do
      create(:button_merge_audio_video_processing_request, command_request: command)

      get "/users/#{user.id}/button_requests", headers: auth_headers
    end

    it { expect(response.body).to include("https://fal.ai/models/fal-ai/flux-2-pro/requests/img-1") }
    it { expect(response.body).to include("https://fal.ai/models/fal-ai/veo3.1/lite/image-to-video/requests/vid-1") }
    it { expect(response.body).to include("https://fal.ai/models/fal-ai/elevenlabs/tts/eleven-v3/requests/aud-1") }

    it "shows a dash for rows without a fal request (old rows, merge, extend prompt)" do
      expect(response.body.scan('<td><span class="muted">—</span></td>').size).to be >= 3
    end
  end
end
