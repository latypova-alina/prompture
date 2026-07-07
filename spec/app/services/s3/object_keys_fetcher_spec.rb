require "rails_helper"

RSpec.describe S3::ObjectKeysFetcher do
  subject(:keys) { described_class.new(prefix:).object_keys }

  let(:prefix) { "audio/samples/" }
  let(:s3_client) { instance_double(Aws::S3::Client) }
  let(:response) do
    instance_double(
      Aws::S3::Types::ListObjectsV2Output,
      contents: [
        instance_double(Aws::S3::Types::Object, key: "audio/samples/adam.mp3"),
        instance_double(Aws::S3::Types::Object, key: "audio/samples/hope.mp3")
      ]
    )
  end

  before do
    allow(Aws::S3::Client).to receive(:new).with(region: ENV.fetch("AWS_REGION")).and_return(s3_client)
    allow(s3_client).to receive(:list_objects_v2).with( # rubocop:disable Naming/VariableNumber
      bucket: ENV.fetch("INTERNAL_BUCKET_NAME"),
      prefix:
    ).and_return(response)
  end

  it "returns the keys under the prefix" do
    expect(keys).to eq(["audio/samples/adam.mp3", "audio/samples/hope.mp3"])
  end
end
