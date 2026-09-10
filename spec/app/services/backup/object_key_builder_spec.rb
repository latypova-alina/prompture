require "rails_helper"

describe Backup::ObjectKeyBuilder do
  subject(:call) { described_class.new.call }

  around { |example| travel_to(Time.utc(2026, 9, 10, 3, 0, 0)) { example.run } }

  it { is_expected.to eq("backups/db/20260910-030000.dump") }
end
