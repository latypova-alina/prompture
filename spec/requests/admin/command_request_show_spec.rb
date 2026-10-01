require "rails_helper"

describe "Admin command request show page" do
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

  {
    command_prompt_to_image_request: "prompt_to_image",
    command_prompt_to_video_request: "prompt_to_video",
    command_image_to_video_request: "image_to_video",
    command_two_frame_to_video_request: "two_frame_to_video",
    command_edit_image_request: "edit_image",
    command_prompt_to_audio_request: "prompt_to_audio"
  }.each do |factory, slug|
    it "renders a #{slug} command request" do
      command_request = create(factory, user:)

      get "/command_requests/#{slug}/#{command_request.id}", headers: auth_headers

      expect(response).to have_http_status(:ok)
      expect(response.body).to include("#{command_request.class.name}##{command_request.id}")
    end
  end

  it "requires authentication" do
    get "/command_requests/prompt_to_image/1"

    expect(response).to have_http_status(:unauthorized)
  end

  it "returns 404 for an unknown type" do
    get "/command_requests/kernel/1", headers: auth_headers

    expect(response).to have_http_status(:not_found)
  end

  it "returns 404 for a button type on the command page" do
    button_request = create(:button_image_processing_request)

    get "/command_requests/image_processing/#{button_request.id}", headers: auth_headers

    expect(response).to have_http_status(:not_found)
  end

  it "returns 404 for a missing id" do
    get "/command_requests/prompt_to_image/0", headers: auth_headers

    expect(response).to have_http_status(:not_found)
  end

  describe "contents" do
    let(:command_request) { create(:command_image_to_video_request, user:) }

    before do
      create(:user_picture_message, command_request:, parent_request: command_request, picture_id: "AgACpic")
      create(:prompt_message, command_request:, parent_request: command_request, prompt: "make it move")
      create_list(:button_video_processing_request, 2, command_request:)
      create(:button_extend_prompt_request, :completed, command_request:, parent_request: command_request)

      get "/command_requests/image_to_video/#{command_request.id}", headers: auth_headers
    end

    it "links to the user" do
      expect(response.body).to include(%(href="/users/#{user.id}"))
    end

    it "lists the inputs" do
      expect(response.body).to include("AgACpic").and include("make it move")
    end

    it "shows each picture input's stored image as a preview and a full link, without N+1 queries" do
      2.times do |i|
        picture = create(:user_picture_message, command_request:, parent_request: command_request)
        create(:stored_image, source_message: picture, image_url: "https://bucket.example.com/p#{i}.jpg")
      end

      get "/command_requests/image_to_video/#{command_request.id}", headers: auth_headers

      expect(response.body).to include(%(<img alt="Input image" src="https://bucket.example.com/p0.jpg"))
      expect(response.body).to include(
        %(href="https://bucket.example.com/p1.jpg">https://bucket.example.com/p1.jpg</a>)
      )
    end

    it "lists button requests linking to their show pages, without N+1 queries" do
      ButtonVideoProcessingRequest.find_each do |button_request|
        expect(response.body).to include(%(href="/button_requests/video_processing/#{button_request.id}"))
      end
      expect(response.body).to include("/button_requests/extend_prompt/")
    end
  end
end
