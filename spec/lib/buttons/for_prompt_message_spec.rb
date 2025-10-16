require "rails_helper"

describe Buttons::ForPromptMessage do
  describe ".buttons" do
    let(:expected_buttons) do
      [
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
