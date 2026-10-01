require "rails_helper"

describe "Admin requests" do
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
  let!(:command_request) { create(:command_prompt_to_image_request, user:) }
  let!(:button_request) do
    create(:button_image_processing_request, :completed, command_request:, parent_request: command_request)
  end

  describe "GET /requests" do
    it "requires authentication" do
      get "/requests"

      expect(response).to have_http_status(:unauthorized)
    end

    it "lists command and button requests together, with kind, user, and status" do
      get "/requests", headers: auth_headers

      expect(response.body).to include("#{command_request.class.name}##{command_request.id}")
      expect(response.body).to include(button_request.created_at.to_s)
      expect(response.body).to include("Rihanna")
      expect(response.body).to include("badge-completed")
    end

    it "filters by user search" do
      other_user = create(:user, :with_balance, name: "Beyonce")
      other_command = create(:command_prompt_to_image_request, user: other_user)

      get "/requests", params: { user: "Rihanna" }, headers: auth_headers

      expect(response.body).to include("#{command_request.class.name}##{command_request.id}")
      expect(response.body).not_to include("#{other_command.class.name}##{other_command.id}")
    end

    it "filters by date range" do
      old_command = create(:command_prompt_to_image_request, user:, created_at: 5.days.ago)

      get "/requests", params: { date_from: 2.days.ago.to_date.to_s }, headers: auth_headers

      expect(response.body).to include("#{command_request.class.name}##{command_request.id}")
      expect(response.body).not_to include("#{old_command.class.name}##{old_command.id}")
    end

    it "does not show type/status/processor filters" do
      get "/requests", headers: auth_headers

      expect(response.body).not_to include('name="type"')
      expect(response.body).not_to include('name="status"')
      expect(response.body).not_to include('name="processor"')
    end

    it "paginates results" do
      create_list(:command_prompt_to_image_request, 20, user:)

      get "/requests", headers: auth_headers

      expect(response.body).to include("Page 1 of 2")
    end
  end

  describe "sorting" do
    def position(record)
      response.body.index("#{record.class.name}##{record.id}")
    end

    it "sorts by kind" do
      get "/requests", params: { sort: "kind", direction: "asc" }, headers: auth_headers

      expect(position(button_request)).to be < position(command_request)
    end

    it "puts command rows (no status) last when sorting by status" do
      get "/requests", params: { sort: "status", direction: "desc" }, headers: auth_headers

      expect(position(button_request)).to be < position(command_request)
    end
  end
end
