require "rails_helper"

describe Backup::PostgresDumper do
  subject(:call) { described_class.new.call }

  before { ENV["DATABASE_URL"] = "postgres://user:pass@localhost:5432/prompture_test" }

  after { ENV.delete("DATABASE_URL") }

  context "when pg_dump succeeds" do
    before do
      allow(Open3).to receive(:capture3).and_return(
        ["dump-bytes", "", instance_double(Process::Status, success?: true)]
      )
    end

    it "calls pg_dump with the database URL in custom format" do
      call

      expect(Open3).to have_received(:capture3).with(
        "pg_dump", ENV.fetch("DATABASE_URL"), "-Fc", binmode: true
      )
    end

    it "returns the dump bytes" do
      expect(call).to eq("dump-bytes")
    end
  end

  context "when pg_dump fails" do
    before do
      allow(Open3).to receive(:capture3).and_return(
        ["", "some error", instance_double(Process::Status, success?: false)]
      )
    end

    it "raises an error" do
      expect { call }.to raise_error(RuntimeError, /pg_dump failed/)
    end
  end
end
