require "rails_helper"

describe Generator::Processors do
  describe "constants" do
    it "defines prompt extension processor" do
      expect(described_class::PROMPT_EXTENSION).to eq("extend_prompt")
    end

    it "defines image processors" do
      expect(described_class::IMAGE).to eq(
        %w[flux_image nano_banana_image imagen_image]
      )
    end

    it "defines edit image processors" do
      expect(described_class::EDIT_IMAGE).to eq(
        %w[nano_banana_edit_image]
      )
    end

    it "defines video processors" do
      expect(described_class::VIDEO).to eq(
        %w[kling_2_1_pro_image_to_video hailuo_02_standard_image_to_video veo3_1_lite_image_to_video]
      )
    end

    it "defines audio processors" do
      expect(described_class::AUDIO).to eq(
        %w[elevenlabs_turbo_v2_5_audio]
      )
    end
  end
end
