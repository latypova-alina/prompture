require "rails_helper"

describe MediaGenerator::GenerationStatus::ForNonCancellablePresenter do
  subject(:presenter) { described_class.new(request) }

  let(:request) { create(:button_image_processing_request) }

  describe "#inline_keyboard" do
    it "returns only the check status button" do
      expect(presenter.inline_keyboard).to eq(
        [
          [
            {
              text: I18n.t("errors.check_status_button"),
              callback_data: "#{ButtonActions::CHECK_GENERATION_STATUS}:#{request.id}:#{request.class.name}"
            }
          ]
        ]
      )
    end
  end

  describe "#message_payload_text" do
    it "returns translated image interim message" do
      expect(presenter.message_payload_text).to eq(I18n.t("errors.media_generating_interim"))
    end
  end
end
