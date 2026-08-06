require "rails_helper"

RSpec.describe Audio::SampleMessagePresenter do
  subject(:formatted_text) { described_class.new(locale: :en).formatted_text }

  before do
    stub_const("ENV", ENV.to_hash.merge("INTERNAL_BUCKET_BASE_URL" => "https://bucket.example"))
    all_keys = %w[adam victoria knox milo hope lulu_lollipop].map { |slug| "admin/audio/samples/#{slug}.mp3" }
    allow(S3::ObjectKeysFetcher).to receive(:new).and_return(
      instance_double(S3::ObjectKeysFetcher, object_keys: all_keys)
    )
  end

  it "includes an intro and a link line for each voice" do
    expect(formatted_text).to include("Here are the voice samples 🔊")
    expect(formatted_text).to include('Adam: <a href="https://bucket.example/admin/audio/samples/adam.mp3">Listen</a>')
    expect(formatted_text).to include('Hope: <a href="https://bucket.example/admin/audio/samples/hope.mp3">Listen</a>')
  end
end
