require "rails_helper"

describe DatabaseBackupJob do
  subject(:perform) { described_class.new.perform }

  let(:uploader) { instance_double(StoreMedia::Upload::S3ObjectUploader, upload: nil) }

  before do
    allow(Backup::PostgresDumper).to receive(:new).and_return(
      instance_double(Backup::PostgresDumper, call: "dump-bytes")
    )
    allow(Backup::ObjectKeyBuilder).to receive(:new).and_return(
      instance_double(Backup::ObjectKeyBuilder, call: "backups/db/20260910-030000.dump")
    )
    allow(StoreMedia::Upload::S3ObjectUploader).to receive(:new).and_return(uploader)
  end

  it "uploads a fresh pg_dump to the configured object key" do
    perform

    expect(StoreMedia::Upload::S3ObjectUploader).to have_received(:new).with(
      bytes: "dump-bytes",
      object_key: "backups/db/20260910-030000.dump",
      content_type: "application/octet-stream"
    )
    expect(uploader).to have_received(:upload)
  end
end
