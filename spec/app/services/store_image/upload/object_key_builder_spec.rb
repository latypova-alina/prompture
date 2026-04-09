require "rails_helper"

describe StoreImage::Upload::ObjectKeyBuilder do
  subject(:object_key) { described_class.new(filename:).object_key }

  let(:filename) { "image.jpg" }

  before do
    allow(SecureRandom).to receive(:uuid).and_return("uuid-123")
    allow(Time).to receive(:now).and_return(Time.utc(2026, 4, 9, 10, 0, 0))
  end

  it "builds object key with date, uuid, and filename" do
    expect(object_key).to eq("images/20260409/uuid-123-image.jpg")
  end
end
