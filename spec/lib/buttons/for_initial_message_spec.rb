require "rails_helper"

describe Buttons::ForInitialMessage do
  describe ".buttons" do
    let(:expected_buttons) do
      [
        [
          {
            "text": "Extend prompt",
            "callback_data": "extend_prompt"
          }
        ],
        [
          {
            "text": "Gemini (0.04€)",
            "callback_data": "gemini_image"
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
