require "rails_helper"

describe Buttons::ForCartoonScriptAudio do
  subject(:result) { described_class.build(locale:) }

  let(:locale) { :en }

  it "builds merge audio to video button" do
    expect(result).to eq(
      [
        [{ callback_data: "merge_cartoon_audio_video", text: "Merge Audio to Video (1 credit)" }]
      ]
    )
  end
end
