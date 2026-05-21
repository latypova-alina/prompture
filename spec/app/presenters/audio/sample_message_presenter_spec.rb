require "rails_helper"

RSpec.describe Audio::SampleMessagePresenter do
  subject(:formatted_text) { described_class.new(locale: :en).formatted_text }

  before do
    stub_const("ENV", ENV.to_hash.merge("INTERNAL_BUCKET_BASE_URL" => "https://bucket.example"))
  end

  it "includes an intro and a link line for each voice" do
    expect(formatted_text).to include("Here are the voice samples 🔊")
    expect(formatted_text).to include('Adam: <a href="https://bucket.example/audio/samples/adam.mp3">Listen</a>')
    expect(formatted_text).to include('Hope: <a href="https://bucket.example/audio/samples/hope.mp3">Listen</a>')
  end
end
