require "rails_helper"

describe ScriptGenerator::ForBloomy::ShortComplexScript::Processor do
  subject(:process_complex_script) { described_class.call(chat_id: 456) }

  let(:scenes) { Array.new(5) { |index| "Scene #{index + 1}" } }
  let(:reference_image_url) { "https://example.com/bloomy.png" }
  let(:context) do
    instance_double(
      ScriptGenerator::ForBloomy::ShortComplexScript::Context,
      scenes:,
      reference_image_url:
    )
  end

  before do
    allow(ScriptGenerator::ForBloomy::ShortComplexScript::Context).to receive(:new)
      .and_return(context)
    allow(ScriptGenerator::ForBloomy::ShortComplexScript::Generator).to receive(:call)
  end

  it "passes context data to the generator" do
    process_complex_script

    expect(ScriptGenerator::ForBloomy::ShortComplexScript::Generator).to have_received(:call).with(
      chat_id: 456,
      scenes:,
      reference_image_url:
    )
  end
end
