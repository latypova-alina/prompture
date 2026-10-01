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

      expect(response.body).to include(%(href="/command_requests/prompt_to_image/#{image_command.id}"))

      expect(response.body).to include("#{image_command.class.name}##{image_command.id}")
      expect(response.body).to include("#{audio_command.class.name}##{audio_command.id}")
    end

    it "filters by type" do
      get "/users/#{user.id}/command_requests", params: { type: "CommandPromptToAudioRequest" }, headers: auth_headers

      expect(response.body).to include("#{audio_command.class.name}##{audio_command.id}")
      expect(response.body).not_to include("#{image_command.class.name}##{image_command.id}")
    end

    it "paginates results" do
      create_list(:command_prompt_to_image_request, 20, user:)

      get "/users/#{user.id}/command_requests", headers: auth_headers

      expect(response.body).to include("Page 1 of 2")
    end

    it "lists each command's button requests with a status badge, oldest first" do
      create(:button_extend_prompt_request, :completed, command_request: image_command, parent_request: image_command,
                                                        created_at: 2.days.ago)
      image_request = create(:button_image_processing_request, command_request: image_command,
                                                               parent_request: image_command, created_at: 1.day.ago)

      get "/users/#{user.id}/command_requests", headers: auth_headers

      expect(response.body).to match(
        /ButtonExtendPromptRequest#\d+.*badge-completed.*ButtonImageProcessingRequest##{image_request.id}/m
      )
    end

    it "loads button requests for many rows without N+1 queries" do
      create_list(:command_prompt_to_image_request, 3, user:).each do |command|
        create(:button_image_processing_request, command_request: command, parent_request: command)
      end

      get "/users/#{user.id}/command_requests", headers: auth_headers

      expect(response).to have_http_status(:ok)
    end

    it "shows a dash for commands without button requests" do
      get "/users/#{user.id}/command_requests", headers: auth_headers

      expect(response.body).to include('<span class="muted">—</span>')
    end

    it "filters by has_button_requests" do
      create(:button_extend_prompt_request, command_request: audio_command, parent_request: audio_command)

      get "/users/#{user.id}/command_requests", params: { has_button_requests: "without" }, headers: auth_headers

      expect(response.body).to include("#{image_command.class.name}##{image_command.id}")
      expect(response.body).not_to include("#{audio_command.class.name}##{audio_command.id}")
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

      expect(response.body).to include("#{image_command.class.name}##{image_command.id}")
      expect(response.body).to include("#{other_command.class.name}##{other_command.id}")
      expect(response.body).to include("Rihanna").and include("Beyonce")
    end

    it "filters by user search" do
      other_user = create(:user, :with_balance, name: "Beyonce")
      other_command = create(:command_prompt_to_image_request, user: other_user)

      get "/command_requests", params: { user: "Rihanna" }, headers: auth_headers

      expect(response.body).to include("#{image_command.class.name}##{image_command.id}")
      expect(response.body).not_to include("#{other_command.class.name}##{other_command.id}")
    end

    it "filters by has_button_requests" do
      create(:button_image_processing_request, :completed, command_request: image_command,
                                                           parent_request: image_command)

      get "/command_requests", params: { has_button_requests: "with" }, headers: auth_headers

      expect(response.body).to include("#{image_command.class.name}##{image_command.id}")
      expect(response.body).not_to include("#{audio_command.class.name}##{audio_command.id}")
    end
  end

  describe "sorting" do
    def position(record)
      response.body.index("#{record.class.name}##{record.id}")
    end

    it "sorts by type when asked" do
      get "/command_requests", params: { sort: "type", direction: "asc" }, headers: auth_headers

      expect(position(audio_command)).to be < position(image_command)
    end

    it "sorts by type descending" do
      get "/command_requests", params: { sort: "type", direction: "desc" }, headers: auth_headers

      expect(position(image_command)).to be < position(audio_command)
    end

    it "keeps the has_button_requests filter in header links" do
      get "/users/#{user.id}/command_requests", params: { has_button_requests: "without" }, headers: auth_headers

      expect(response.body).to include("direction=asc&amp;has_button_requests=without&amp;sort=category")
    end
  end
end
