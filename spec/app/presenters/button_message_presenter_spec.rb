require "rails_helper"

describe ButtonMessagePresenter do
  let(:message) { "Sample message" }
  let(:message_type) { "image_message" }
  let(:button_request) { "mystic_image" }
  let(:regenerate) { false }

  subject { described_class.new(message, message_type, button_request, regenerate) }

  let(:expected_reply_data) do
    {
      parse_mode: "HTML",
      reply_markup: {
        inline_keyboard: [
          [
            {
              callback_data: "mystic_image",
              text: "Regenerate Mystic (Realistic, 0.1€)"
            }
          ]
        ]
      },
      text: "<a href=\"Sample message\">Open image</a>"
    }
  end

  describe "#reply_data" do
    subject { super().reply_data }

    it { is_expected.to eq(expected_reply_data) }
  end
end
