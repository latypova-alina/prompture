require "rails_helper"

describe "Admin button request show page" do
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

  {
    button_image_processing_request: "image_processing",
    button_video_processing_request: "video_processing",
    button_audio_processing_request: "audio_processing",
    button_merge_audio_video_processing_request: "merge_audio_video_processing",
    button_extend_prompt_request: "extend_prompt"
  }.each do |factory, slug|
    it "renders a #{slug} button request" do
      button_request = create(factory)

      get "/button_requests/#{slug}/#{button_request.id}", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("#{button_request.class.name}##{button_request.id}")
    end
  end

  it "requires authentication" do
    get "/button_requests/image_processing/1"

    expect(response).to have_http_status(:unauthorized)
  end

  it "returns 404 for an unknown type" do
    get "/button_requests/kernel/1", headers: auth_headers

    expect(response).to have_http_status(:not_found)
  end

  it "returns 404 for a missing id" do
    get "/button_requests/image_processing/0", headers: auth_headers

    expect(response).to have_http_status(:not_found)
  end

  describe "links" do
    let(:user) { create(:user, :with_balance, name: "Rihanna") }
    let(:command_request) { create(:command_prompt_to_image_request, user:) }
    let(:image_request) do
      create(:button_image_processing_request, :completed, command_request:, parent_request: command_request)
    end
    let!(:child) { create(:button_video_processing_request, command_request:, parent_request: image_request) }

    before { get "/button_requests/image_processing/#{image_request.id}", headers: auth_headers }

    it { expect(response.body).to include(%(href="/users/#{user.id}")) }
    it { expect(response.body).to include(%(href="/command_requests/prompt_to_image/#{command_request.id}")) }
    it { expect(response.body).to include(%(href="/button_requests/video_processing/#{child.id}")) }

    it "shows the provider URL as a full link" do
      expect(response.body).to include(
        %(<a target="_blank" rel="noopener" href="http://example.com/image.png">http://example.com/image.png</a>)
      )
    end

    it "previews the image" do
      expect(response.body).to include(%(<img alt="Result" src="http://example.com/image.png"))
    end
  end

  context "when the parent is a button request" do
    let(:child) { create(:button_video_processing_request) }

    before { get "/button_requests/video_processing/#{child.id}", headers: auth_headers }

    it "links to the parent's show page" do
      parent = child.parent_request

      expect(response.body).to include(%(href="/button_requests/image_processing/#{parent.id}"))
    end

    it { expect(response.body).to include(%(<img alt="Input image" src="http://example.com/image.png")) }
  end

  context "when the parent is a message record" do
    let(:button_request) { create(:button_image_processing_request) }

    before { get "/button_requests/image_processing/#{button_request.id}", headers: auth_headers }

    it "shows it as plain text" do
      expect(response.body).to include("PromptMessage##{button_request.parent_request_id}")
      expect(response.body).not_to include("/prompt_messages/")
    end
  end
end
