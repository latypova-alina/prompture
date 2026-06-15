require "rails_helper"

describe Generator::Media::Merge::CreateTask::MediaDownloader do
  subject(:tempfile) { described_class.new(url, ext).tempfile }

  let(:url) { "https://example.com/video.mp4" }
  let(:ext) { ".mp4" }
  let(:file_content) { "binary content" }

  before do
    stub_request(:get, url).to_return(body: file_content)
  end

  it "returns a tempfile with the downloaded content" do
    result = tempfile

    expect(result).to be_a(Tempfile)
    expect(result.read).to eq(file_content)
  end

  it "returns the tempfile rewound to the start" do
    result = tempfile

    expect(result.pos).to eq(0)
  end
end
