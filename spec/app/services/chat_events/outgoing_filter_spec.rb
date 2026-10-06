require "rails_helper"

describe ChatEvents::OutgoingFilter do
  describe ".recorded_method?" do
    it { expect(described_class.recorded_method?("sendMessage")).to be(true) }
    it { expect(described_class.recorded_method?("setMyCommands")).to be(false) }
    it { expect(described_class.recorded_method?("createInvoiceLink")).to be(false) }
  end

  describe ".recorded_chat?" do
    before { stub_const("ENV", ENV.to_hash.merge("ADMIN_CHAT_ID" => "-100")) }

    it { expect(described_class.recorded_chat?(111)).to be(true) }
    it { expect(described_class.recorded_chat?(-100)).to be(false) }
    it { expect(described_class.recorded_chat?(nil)).to be(false) }
  end
end
