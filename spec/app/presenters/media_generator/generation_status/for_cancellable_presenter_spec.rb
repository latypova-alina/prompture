require "rails_helper"

describe MediaGenerator::GenerationStatus::ForCancellablePresenter do
  subject(:presenter) { described_class.new(request) }

  let(:request) { create(:button_video_processing_request) }

  describe "#inline_keyboard" do
    it "returns check status and cancel buttons" do
      expect(presenter.inline_keyboard).to eq(
        [
          [
            {
              text: I18n.t("errors.check_status_button"),
              callback_data: "#{ButtonActions::CHECK_GENERATION_STATUS}:#{request.id}:#{request.class.name}"
            },
            {
              text: I18n.t("errors.cancel_generation_button"),
              callback_data: "#{ButtonActions::CANCEL_GENERATION}:#{request.id}:#{request.class.name}"
            }
          ]
        ]
      )
    end
  end

  describe "#message_payload_text" do
    it "returns translated video interim message" do
      expect(presenter.message_payload_text).to eq(I18n.t("errors.video_generating_interim"))
    end
  end
end
