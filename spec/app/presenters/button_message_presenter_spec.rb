require "rails_helper"

describe ButtonMessagePresenter do
  let(:message) { "Sample message" }
  let(:message_type) { "image_message" }
  let(:button_request) { "mystic_image" }

  subject { described_class.new(message, message_type, button_request) }

  let(:expected_reply_data) do
    {
      parse_mode: "HTML",
      reply_markup: {
        inline_keyboard: [
          [
            {
              callback_data: "gemini_image",
              text: "Gemini (0.035€)"
            }
          ],
          [
            {
              callback_data: "imagen_image",
              text: "Imagen3 (0.04€)"
            }
          ],
          [
            {
              callback_data: "mystic_image",
              text: "Mystic (0.1€)"
            }
          ],
          [
            {
              callback_data: "kling_2_1_pro_image_to_video",
              text: "Kling Pro 2.1 (0.42€)"
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
