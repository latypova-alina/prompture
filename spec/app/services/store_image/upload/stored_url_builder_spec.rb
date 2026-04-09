require "rails_helper"

describe StoreImage::Upload::StoredUrlBuilder do
  subject(:stored_url) { described_class.new(object_key:).stored_url }

  let(:object_key) { "images/20260409/uuid-image.jpg" }

  before do
    allow(ENV).to receive(:fetch).with("INTERNAL_BUCKET_BASE_URL").and_return("https://internal.example")
  end

  it "builds stored url from base url and object key" do
    expect(stored_url).to eq("https://internal.example/#{object_key}")
  end
end
