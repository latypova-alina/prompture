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
      create(:button_image_processing_request, :completed, command_request:, parent_request: command_request,
                                                           fal_request_id: "fal-1")
    end
    let!(:child) { create(:button_video_processing_request, command_request:, parent_request: image_request) }

    before { get "/button_requests/image_processing/#{image_request.id}", headers: auth_headers }

    it { expect(response.body).to include(%(href="/users/#{user.id}")) }
    it { expect(response.body).to include(%(href="/command_requests/prompt_to_image/#{command_request.id}")) }
    it { expect(response.body).to include(%(href="/button_requests/video_processing/#{child.id}")) }

    it { expect(response.body).to include(%(href="https://fal.ai/models/fal-ai/flux-2-pro/requests/fal-1">fal-1</a>)) }

    it "shows the result URL as a full link" do
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

  describe "a generation fal rejected" do
    let(:button_request) do
      create(:button_image_processing_request, status: "FAILED", failure_reason: "content_flagged",
                                               failure_message: "flagged by a content checker",
                                               fal_payload: { prompt: "a cat", image_size: "square_hd" })
    end

    before { get "/button_requests/image_processing/#{button_request.id}", headers: auth_headers }

    it { expect(response.body).to include("content_flagged") }
    it { expect(response.body).to include("flagged by a content checker") }
    it { expect(response.body).to include("&quot;prompt&quot;: &quot;a cat&quot;") }
  end

  describe "input moderation" do
    subject(:body) do
      get "/button_requests/image_processing/#{button_request.id}", headers: auth_headers
      response.body
    end

    let(:button_request) { create(:button_image_processing_request) }

    it { is_expected.not_to include("Input moderation") }

    context "when the prompt was moderated" do
      before do
        create(:moderation_result, :blocked, command_request: button_request.command_request,
                                             moderatable: button_request.parent_request)
      end

      it { is_expected.to include("Input moderation") }
      it { is_expected.to include("PromptMessage##{button_request.parent_request_id}") }
      it { is_expected.to include("blocked: violence_score") }
    end
  end

  describe "generated image moderation" do
    subject(:body) do
      get "/button_requests/image_processing/#{button_request.id}", headers: auth_headers
      response.body
    end

    let(:button_request) { create(:button_image_processing_request) }

    it { is_expected.not_to include("Generated image moderation") }

    context "when the generated image was moderated" do
      before do
        create(:moderation_result, :blocked, input_kind: "image", input_text: nil, moderatable: button_request,
                                             command_request: button_request.command_request)
      end

      it { is_expected.to include("Generated image moderation") }
      it { is_expected.to include("blocked: violence_score") }
    end
  end
end
