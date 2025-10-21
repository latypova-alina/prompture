require "rails_helper"

describe Buttons::ForPromptMessage do
  describe ".buttons" do
    let(:expected_buttons) do
      [
        [
          {
            "text": "Gemini (0.035€)",
            "callback_data": "gemini_image"
          }
        ],
        [
          {
            "text": "Imagen3 (0.04€)",
            "callback_data": "imagen_image"
          }
        ],
        [
          {
            "text": "Mystic (0.1€)",
            "callback_data": "mystic_image"
          }
        ]
      ]
    end

    subject { described_class.buttons }

    it { is_expected.to eq(expected_buttons) }
  end
end
