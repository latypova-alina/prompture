require "rails_helper"

describe ScriptGenerator::ForBloomy::ShortComplexScript::Context do
  subject(:context) { described_class.new }

  let(:payload) do
    {
      "scenes" => Array.new(5) { |index| "Scene #{index + 1}" },
      "reference_image_url" => "https://example.com/bloomy.png"
    }
  end
  let(:cartoon_problem_solution_script_payload) do
    instance_double(ScriptGenerator::ForBloomy::Payloads::ForCartoonProblemSolutionScript, payload:)
  end

  before do
    allow(ScriptGenerator::ForBloomy::Payloads::ForCartoonProblemSolutionScript).to receive(:new)
      .and_return(cartoon_problem_solution_script_payload)
  end

  it "returns scenes from payload" do
    expect(context.scenes).to eq(payload["scenes"])
  end

  it "returns reference_image_url from payload" do
    expect(context.reference_image_url).to eq(payload["reference_image_url"])
  end

  it "fetches cartoon problem solution script payload once" do
    context.scenes
    context.reference_image_url

    expect(ScriptGenerator::ForBloomy::Payloads::ForCartoonProblemSolutionScript).to have_received(:new).once
  end
end
