require "rails_helper"

describe Buttons::ForVideoMessage do
  describe ".buttons" do
    let(:expected_buttons) do
      [
        [
          {
            "text": "Kling Pro 2.1 (0.42€)",
            "callback_data": "kling_2_1_pro_image_to_video"
          }
        ]
      ]
    end

    subject { described_class.buttons }

    it { is_expected.to eq(expected_buttons) }
  end
end
