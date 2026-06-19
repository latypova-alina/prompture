require "rails_helper"

describe ScriptGenerator::ForCartoon::ProcessScriptVideoPrompt do
  subject(:process_script_video_prompt) { described_class.call(script:) }

  let(:script) { create(:script, script_text: "Bloomy waves hello.") }
  let(:video_prompt) { "Slow zoom on Bloomy waving." }
  let(:video_prompt_context) { instance_double(ScriptGenerator::ForCartoon::VideoPromptContext, prompt: video_prompt) }

  before do
    allow(ScriptGenerator::ForCartoon::VideoPromptContext)
      .to receive(:new)
      .with(script_text: script.script_text)
      .and_return(video_prompt_context)
  end

  it "creates a video prompt and links it to the script" do
    expect { process_script_video_prompt }
      .to change(VideoPrompt, :count).by(1)
      .and change { script.reload.video_prompt&.prompt }.from(nil).to(video_prompt)

    expect(process_script_video_prompt).to eq(VideoPrompt.last)
    expect(process_script_video_prompt.prompt).to eq(video_prompt)
  end

  context "when the script already has a video prompt" do
    let!(:existing_video_prompt) { create(:video_prompt, prompt: "Existing video prompt.") }

    before { script.update!(video_prompt: existing_video_prompt) }

    it "reuses the existing video prompt without calling the script API" do
      expect { process_script_video_prompt }
        .not_to change(VideoPrompt, :count)

      expect(ScriptGenerator::ForCartoon::VideoPromptContext).not_to have_received(:new)
      expect(process_script_video_prompt).to eq(existing_video_prompt)
    end
  end
end
