require "rails_helper"

describe Generator::Processors do
  describe "constants" do
    it "defines prompt extension processor" do
      expect(described_class::PROMPT_EXTENSION).to eq("extend_prompt")
    end

    it "defines image processors" do
      expect(described_class::IMAGE).to eq(
        %w[mystic_image flux_image gemini_image imagen_image]
      )
    end

    it "defines video processors" do
      expect(described_class::VIDEO).to eq(
        %w[kling_2_1_pro_image_to_video wan_2_2_image_to_video]
      )
    end

    it "defines audio processors" do
      expect(described_class::AUDIO).to eq(
        %w[elevenlabs_turbo_v2_5_audio]
      )
    end
  end
end
