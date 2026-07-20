require "rails_helper"

describe Generator::Media::Image::NotifySuccess::SuccessNotifierRouter do
  subject(:route) do
    described_class.call(image_url:, button_request_id: button_request.id)
  end

  let(:image_url) { "http://example.com/image.png" }
  let(:user) { create(:user) }
  let(:category) { ContentCategory::MOTIVATION }
  let(:command_request) { create(:command_edit_image_request, user:, category:) }
  let(:button_request) do
    create(
      :button_image_processing_request,
      user:,
      command_request:,
      parent_request: command_request
    )
  end

  before do
    allow(Generator::Media::Image::NotifySuccess::SuccessNotifier).to receive(:call)
    allow(Generator::Media::Image::NotifySuccess::ForBloomy::SuccessNotifier).to receive(:call)
  end

  it "routes to the default success notifier" do
    route

    expect(Generator::Media::Image::NotifySuccess::SuccessNotifier)
      .to have_received(:call)
      .with(image_url:, button_request_id: button_request.id)
    expect(Generator::Media::Image::NotifySuccess::ForBloomy::SuccessNotifier)
      .not_to have_received(:call)
  end

  context "when command request is complex bloomy shorts" do
    let(:category) { ContentCategory::CARTOON_BLOOMY_SHORTS_COMPLEX_SCRIPT }

    it "routes to the bloomy success notifier" do
      route

      expect(Generator::Media::Image::NotifySuccess::ForBloomy::SuccessNotifier)
        .to have_received(:call)
        .with(image_url:, button_request_id: button_request.id)
      expect(Generator::Media::Image::NotifySuccess::SuccessNotifier)
        .not_to have_received(:call)
    end
  end
end
